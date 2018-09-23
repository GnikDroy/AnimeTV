package com.scraper;


import java.util.*;
import java.io.IOException;

import com.google.gson.*;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.jsoup.parser.Parser;

public class SiteTools {

    /**
     * This function returns the List of all anime from the anime1 site
     * This list is used to search for anime.
     * Each element in the list is a list in itself that contains two things.
     * First element is the title of the anime and the second is the link to the anime
     *
     * @param response The response object after connecting to the anime1 site.
     * @return List of all anime found
     */
    public static List<List<String>> getAnimeList(String response) {
        Document document = Jsoup.parse(response);
        List<List<String>> animeList = new ArrayList<>();
        Elements links = document.select("ul.anime-list>li>a");
        for (Element link : links) {
            animeList.add(new ArrayList<>(Arrays.asList(link.text(), link.attr("href"))));
        }
        return animeList;

    }

    /**
     * This function returns the List of all ongoing anime from the anime1 site
     * This list is used for the front page of the app
     * Each element in the list is a list in itself that contains two things.
     * First element is the title of the anime and the second is the link to the anime
     * The third element is the img url of the anime cover
     *
     * @param string_document The html document of anime1 ongoing page.
     * @return List of all anime found
     */

    public static List<List<String>> getOngoingAnimeList(String string_document) {
        Document document = Jsoup.parse(string_document);
        List<List<String>> ongoingAnimeList = new ArrayList<>();
        Elements anime_list = document.select("div.an-list>div");
        for (Element anime : anime_list) {
            String anime_url = "", image_url = "", title = "";
            for (Element animeDetail : anime.children()) {
                if (animeDetail.className().equals("an-image")) {
                    anime_url = animeDetail.child(0).attr("href"); //First child is the a href link of image. You can get the url from here.
                    image_url = animeDetail.child(0).child(0).attr("src"); //The child of that element is the image tag itself. You can get the image from here.
                }
                if (animeDetail.className().equals("an-text")) {
                    title = animeDetail.child(0).text();//First child is the h2 tag which can be used to get text.
                }
            }
            ongoingAnimeList.add(new ArrayList<>(Arrays.asList(title, anime_url, image_url)));
        }
        return ongoingAnimeList;
    }

    /**
     * This function returns the genre availiable in the anime1 site
     * The first item is the Title of genre and second is the url to genre page
     *
     * @param response
     * @return
     */
    public static List<List<String>> getGenreList(String response) {
        String url = "http://www.anime1.com/content/genre/";
        List<List<String>> genreList = new ArrayList<>();
        Document document = Jsoup.parse(response);
        Elements links = document.select("div.popularity-by-genre>ul>li>a");
        for (Element link : links) {
            genreList.add(new ArrayList<>(Arrays.asList(link.text(), link.attr("href"))));
        }
        return genreList;
    }


    //Use this if you ever want to get more than 20 items from genre list. THIS CODE DOESNOT WORK BUT THE METHOD IS SITLL THERE.
    public static Element getAnimeByGenreElement(String url, String genre, int page) throws IOException {
        String document = Jsoup.connect(url).data("NewContent", String.valueOf(page), "selCategory", genre) //Look at this line expecially.
                .header("Accept", "application/json, text/javascript, *; q=0.01")
                .header("X-Requested-With", "XMLHttpRequest")
                .header("Host", "www.anime1.com")
                .header("Origin", "http://www.anime1.com")
                .header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
                .header("Referer", "http://www.anime1.com/content/genre/")
                .execute().body();
        JsonParser parser = new JsonParser();
        JsonObject jsonObject = parser.parse(document).getAsJsonObject();
        Set<String> keys = jsonObject.getAsJsonObject("html").keySet();
        String html = "";
        for (String key : keys) {
            String text = jsonObject.getAsJsonObject("html").get(key).toString().replace("\\n", "\n");
            html += "<div class=\"an-box\">" + text.substring(1, text.length() - 1) + "</div>";
        }
        Document htmlDocument = Jsoup.parse(Parser.unescapeEntities(html, false));
        //These lines add the parent.
        return htmlDocument.child(0).child(1);
    }

    public static List<List<String>> getAnimeByGenre(String url) throws IOException {
        Document document = Jsoup.connect(url).get();
        Element div = document.getElementById("RestList");
        for (Element div_child : div.children()) {
            if (div_child.attr("class").equals("an-box loading afterloaders ")) {
                div_child.remove(); //This filters the afterloaders.
            }
        }
        return getAnimeByGenreElementParse(div);
    }

    public static List<List<String>> getAnimeByGenreElementParse(Element div) {
        List<List<String>> animeList = new ArrayList<>();
        for (Element div_child : div.children()) {
            System.out.println(div_child.html());
            String anime_name = "", anime_link = "", anime_cover = "";
            anime_link = div_child.child(1).child(0).attr("href"); //This is the a href link of the anime.Get the link of anime from here.
            anime_cover = div_child.child(1).child(0).child(0).attr("src");//This is the child of the previous element. This contains an image so extract it's source from here.
            anime_name = div_child.child(2).child(0).text();
            animeList.add(new ArrayList<>(Arrays.asList(anime_name, anime_link, anime_cover)));
        }
        return animeList;
    }


    public static List<List<String>> getAlternateEpisodeLinks(String response) {
        Document document = Jsoup.parse(response);
        Elements links = document.select("div.p-left-buttons>a");
        List<List<String>> episode_links = new ArrayList<>(2);
        for (Element link : links) {
            episode_links.add(new ArrayList<>(Arrays.asList(link.text(), link.attr("href"))));
        }
        return episode_links;
    }

    /**
     * This function returns the videoURL from the episode page of anime1.
     *
     * @param response The document in string format of the anime1 episode page
     * @return Returns the url to the raw video of the episode.
     */
    public static String getVideoURL(String response) {
        String js = "";
        Document document = Jsoup.parse(response);
        Element divElement = document.getElementById("Movie");
        for (Element javascript : divElement.children()) {
            if (javascript.tagName().equals("script")) {
                js = javascript.html();
            }
        }
        int firstIndex = js.indexOf("\"", js.indexOf("file"));
        int secondIndex = js.indexOf("\"", firstIndex + 1);
        String result = js.substring(firstIndex + 1, secondIndex);
        return result;
    }


}
