package com.scraper;


import java.util.*;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


public class Anime {

    private Document animeDocument;
    private String animeName = "";
    private String animeCoverImage = "";
    private List<String> animeDescription = new ArrayList<String>();
    private List<List<String>> animeEpisodeList = new ArrayList<>();

    /**
     * Parses the anime page and constructs a document
     * Sets all properties from the parsed document
     *
     * @param animeDocument The html document from the page.
     */
    public Anime(String animeDocument) {
        this.animeDocument = Jsoup.parse(animeDocument);
        setAnimeName();
        setAnimeCover();
        setAnimeDescription();
        setAnimeEpisodeList();
    }

    /**
     * This function sets the Anime Cover
     */
    private void setAnimeCover() {
        String image_url = "";
        Elements images = animeDocument.select("div.detail-cover>a>img");
        for (Element image : images) {

            image_url = image.attr("src");
        }
        animeCoverImage = image_url;
    }

    /**
     * Sets the anime Title
     */
    private void setAnimeName() {
        String title = animeDocument.select("div.detail-left>h1").get(0).text();
        animeName = title;
    }

    /**
     * Sets the anime Description
     */
    private void setAnimeDescription() {
        ArrayList<String> description = new ArrayList<String>(9);
        Elements details = animeDocument.select("div.detail-left>span");
        for (Element detail : details) {
            for (Element child_details : detail.children()) {
                if (child_details.tagName().equals("div")) {
                    child_details.remove(); //This is necessary to remove the Voice Availabe.. etc text.
                }
                //This if on the other hand handles the sub child's text in a different way. It seperates text of age rating prequel status etc..
                if (child_details.tagName().equals("span")) {
                    description.add(child_details.text());
                    child_details.remove();//This is necessary so that the add function outside the for doesnot duplicate entries.
                }
            }
            description.add(detail.text());
        }
        animeDescription = description;
    }

    /**
     * Constructs the anime Episodes list
     */
    private void setAnimeEpisodeList() {
        List<List<String>> episodeList = new ArrayList<>();
        animeDocument.select("div.latest-box").remove();  //This will remove the redundant latest-box from the top of the page.
        Elements links = animeDocument.select("ul.anime-list>li>a");
        for (Element link : links) {
            episodeList.add(new ArrayList<String>(Arrays.asList(link.text(), link.attr("href"))));
        }
        animeEpisodeList = episodeList;
    }


    public String getAnimeCover() {
        return animeCoverImage;
    }

    public List<String> getAnimeDescription() {
        return animeDescription;
    }

    public List<List<String>> getAnimeEpisodeList() {
        return animeEpisodeList;
    }

    public String getAnimeName() {
        return animeName;
    }


}

