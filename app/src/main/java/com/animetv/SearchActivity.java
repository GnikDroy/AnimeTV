package com.animetv;


import android.app.SearchManager;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;

import com.android.volley.NetworkResponse;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HttpHeaderParser;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.scraper.SiteTools;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import me.xdrop.fuzzywuzzy.FuzzySearch;
import me.xdrop.fuzzywuzzy.model.ExtractedResult;

public class SearchActivity extends AppCompatActivity {
    private static final String TAG = "SearchActivity";
    private RecyclerView recyclerView;
    private SearchAdapter searchAdapter;
    private RequestQueue requestQueue;
    private StringRequest stringRequest;
    private ProgressBar progressBar;
    private List<List<String>> animeList = new ArrayList<>();

    private List<List<String>> searchResults = new ArrayList<>();
    private String mainUrl = "http://www.anime1.com/content/list/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search);
        progressBar = findViewById(R.id.progressBar);
        progressBar.setVisibility(View.VISIBLE);
        recyclerView = findViewById(R.id.recyclerView);
        searchAdapter = new SearchAdapter(searchResults, getApplicationContext());
        recyclerView.setAdapter(searchAdapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        handleIntent(getIntent());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        handleIntent(intent);
    }

    private void handleIntent(Intent intent) {

        if (Intent.ACTION_SEARCH.equals(intent.getAction())) {
            Log.d(TAG, "New intent started");
            String query = intent.getStringExtra(SearchManager.QUERY);
            final String tmp_query = query;
            requestQueue = Volley.newRequestQueue(this);

            //Runs on same thread.
            stringRequest = new StringRequest(Request.Method.GET, mainUrl, new Response.Listener<String>() {
                @Override
                public void onResponse(String response) {
                    searchResults.clear();
                    if (animeList.isEmpty()) {
                        animeList.addAll(SiteTools.getAnimeList(response));
                    }
                    List<String> animeTitles = new ArrayList<>();
                    for (List<String> t : animeList) {
                        animeTitles.add(t.get(0));
                    }
                    //Do all your task here.
                    List<ExtractedResult> results = FuzzySearch.extractTop(tmp_query, animeTitles, 15);
                    List<Integer> indices = new ArrayList<>();
                    for (ExtractedResult e : results) {
                        indices.add(e.getIndex());
                    }
                    //Use the indices to construct a new array list.
                    List<List<String>> filteredResults = new ArrayList<>();

                    for (Integer a : indices) {
                        filteredResults.add(animeList.get(a));
                    }
                    searchResults.addAll(filteredResults);
                    progressBar.setVisibility(View.INVISIBLE);
                    searchAdapter.notifyDataSetChanged();
                }
            }, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError error) {
                    Log.d(TAG, "error in connection");
                }
            });
            requestQueue.add(stringRequest);
            //use the query to search your data somehow
        }
    }
}
