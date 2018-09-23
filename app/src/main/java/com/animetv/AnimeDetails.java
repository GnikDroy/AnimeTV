package com.animetv;


import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.scraper.Anime;
import com.squareup.picasso.Picasso;

public class AnimeDetails extends AppCompatActivity {
    private static final String TAG = "AnimeDetails";
    private TextView animeDescription;
    private ImageView animeCover;
    private Button episodeButton;
    private ProgressBar progressBar;
    private RequestQueue requestQueue;
    private StringRequest stringRequest;
    private String url;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_anime_details);


        //This get the params from the intent.
        Bundle bundle = getIntent().getExtras();
        if(bundle != null) {
            url = bundle.getString("url");
        }
        else{
            //This case causes errors.
        }

        animeDescription=findViewById(R.id.animeDetails);
        //animeDescription.setMovementMethod(new ScrollingMovementMethod());
        animeCover=findViewById(R.id.animeCover);
        episodeButton=findViewById(R.id.episodeButton);
        progressBar=findViewById(R.id.progressBar);

        progressBar.setVisibility(View.VISIBLE);
        animeDescription.setVisibility(View.INVISIBLE);
        animeCover.setVisibility(View.INVISIBLE);
        episodeButton.setVisibility(View.INVISIBLE);

        episodeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent intent=new Intent(getApplicationContext(), EpisodeList.class);
                intent.putExtra("url",url);
                getApplicationContext().startActivity(intent);
            }
        });
        requestQueue= Volley.newRequestQueue(this);
        stringRequest=new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Log.d(TAG,"Got Response");
                Anime anime=new Anime(response.toString());
                Picasso.with(getApplicationContext()).load(anime.getAnimeCover()).fit().centerCrop().into(animeCover);
                episodeButton.setText("Watch "+anime.getAnimeName());
                //This constructs the description
                String text="";
                for (String detail:anime.getAnimeDescription()){
                    text+=detail+"\n\n";
                }
                animeDescription.setText(text);
                progressBar.setVisibility(View.INVISIBLE);
                animeDescription.setVisibility(View.VISIBLE);
                animeCover.setVisibility(View.VISIBLE);
                episodeButton.setVisibility(View.VISIBLE);


            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.d(TAG,"error in connection");
            }
        });
        requestQueue.add(stringRequest);
        Log.d(TAG,"Made the request");

    }
}
