package com.animetv;


import android.content.Context;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.constraint.ConstraintLayout;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;


import com.squareup.picasso.Picasso;

import java.util.List;

public class MainRecyclerViewAdapter extends RecyclerView.Adapter<MainRecyclerViewAdapter.ViewHolder>{
    private static final String TAG = "RecyclerViewAdapter";
    private List<List<String>> animeList;
    private Context context;
    public MainRecyclerViewAdapter(List<List<String>> animeList, Context context) {
        this.animeList = animeList;
        this.context = context;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int i) {
        View view= LayoutInflater.from(parent.getContext()).inflate(R.layout.mainrecyclerview_list_item,parent,false);
        ViewHolder holder=new ViewHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder viewHolder, int i) {

        viewHolder.animeTitle.setText(animeList.get(i).get(0));
        //Load the image
        Picasso.with(context).load(animeList.get(i).get(2)).centerCrop().resize(100, 150).into(viewHolder.animeImage);


        final int  tmp_i=i;
        viewHolder.parent_layout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent=new Intent(context, AnimeDetails.class);
                intent.putExtra("url",animeList.get(tmp_i).get(1));
                context.startActivity(intent);
            }
        });
    }

    @Override
    public int getItemCount() {
        return animeList.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder{
        TextView animeTitle;
        ImageView animeImage;
        ConstraintLayout parent_layout;
        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            animeTitle=itemView.findViewById(R.id.animeTitle);
            animeImage=itemView.findViewById(R.id.animeImage);
            parent_layout=itemView.findViewById(R.id.parent_layout);
        }
    }

}
