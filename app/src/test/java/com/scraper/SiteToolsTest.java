package com.scraper;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.Scanner;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.fail;

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
public class SiteToolsTest {

    private String getDocument(String filename) throws IOException {
        String pathname;
        URL resource=this.getClass().getClassLoader().getResource(filename);
        pathname=resource.getPath();

        File file = new File(pathname);
        StringBuilder fileContents = new StringBuilder((int)file.length());
        Scanner scanner = new Scanner(file);
        String lineSeparator = System.getProperty("line.separator");

        try {
            while(scanner.hasNextLine()) {
                fileContents.append(scanner.nextLine() + lineSeparator);
            }
            return fileContents.toString();
        } finally {
            scanner.close();
        }
    }

    @Test
    public void getsCorrectVideoUrl() {
        String document=null;
        String correctURL="http://st71.anime1.com/One Piece Episode 854_HD.mp4?st=r0e3n168YmTJ3wi61iNGCg&e=1537727842";
        try {
            document = getDocument("episode.html");
        } catch (IOException e) {
            fail("Could not load html test file");
        }

        assertThat(SiteTools.getVideoURL(document).equals(correctURL),is(true));
    }

    @Test public void getsOngoingAnimeList(){
        String document= null;
        try {
            document = getDocument("ongoinganime.html");
        } catch (IOException e) {
            fail("Could not load html test file");
        }
        assertThat((SiteTools.getOngoingAnimeList(document).get(0).get(0).equals("Planet With")),is(true));
        assertThat((SiteTools.getOngoingAnimeList(document).get(0).get(1).equals("http://www.anime1.com/watch/planet-with")),is(true));
        assertThat((SiteTools.getOngoingAnimeList(document).get(0).get(2).equals("http://www.anime1.com/main/img/content/planet-with/planet-with-210.jpg")),is(true));
    }

    @Test
    public void getsAllAnimeList(){
        String document=null;
        try {
            document=getDocument("allanime.html");
        } catch (IOException e) {
            fail("Test HTML file not found.");
        }
        assertThat((SiteTools.getAnimeList(document).get(0).get(0).equals("009-1")),is(true));
        assertThat((SiteTools.getAnimeList(document).get(0).get(1).equals("http://www.anime1.com/watch/009-1")),is(true));
    }
}