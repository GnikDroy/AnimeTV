package com.scraper;

import org.junit.Before;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.Scanner;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;


/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
public class AnimeTest {
    Anime anime;
    private String readFile(String pathname) throws IOException {

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

    @Before
    public void constructAnime() throws IOException{
        String document;
        URL resource=this.getClass().getClassLoader().getResource("anime.html");
        document=readFile(resource.getPath());
        anime=new Anime(document);
    }

    @Test
    public void getsAnimeCover(){
        assertThat(anime.getAnimeCover().equals("http://www.anime1.com/main/img/content/one-piece/one-piece-210.jpg"),is(true));
    }

    @Test
    public void getsAnimeTitle(){
        assertThat(anime.getAnimeName().equals("One Piece"),is(true));
    }

    @Test
    public void getsAnimeDescription(){
        assertThat(anime.getAnimeDescription().get(0).equals("Genre : Drama, Comedy, Fantasy, Action, Shounen, Adventure, Super Power"),is(true));
        assertThat(anime.getAnimeDescription().get(anime.getAnimeDescription().size()-1).equals("Age Rating : Teen +13"),is(true));

    }

    @Test
    public void getsAnimeEpisodeList(){
        assertThat(anime.getAnimeEpisodeList().get(0).get(0).equals("One Piece Episode 1"),is(true));
        assertThat(anime.getAnimeEpisodeList().get(0).get(1).equals("http://www.anime1.com/watch/one-piece/episode-1"),is(true));

        assertThat(anime.getAnimeEpisodeList().get(anime.getAnimeEpisodeList().size()-1).get(0).equals("One Piece Episode 854"),is(true));
        assertThat(anime.getAnimeEpisodeList().get(anime.getAnimeEpisodeList().size()-1).get(1).equals("http://www.anime1.com/watch/one-piece/episode-854"),is(true));

    }

}
