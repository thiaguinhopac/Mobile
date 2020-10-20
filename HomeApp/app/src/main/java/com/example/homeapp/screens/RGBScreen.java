package com.example.homeapp.screens;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import yuku.ambilwarna.AmbilWarnaDialog;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;

import com.example.homeapp.R;
import com.example.homeapp.entities.JSON;
import com.example.homeapp.entities.UDP;

import org.json.JSONException;

import java.io.IOException;
import java.net.SocketException;
import java.net.UnknownHostException;

public class RGBScreen extends AppCompatActivity {

    private View contentView;
    int color =  0xffffff00;
    UDP udp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_r_g_b_screen);

        try {
            contentView = (View) findViewById(R.id.bgRGB);
            ImageButton floatingActionButton = findViewById(R.id.imageButton);
            floatingActionButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    showPopup();
                }
            });

            udp = new UDP();

        } catch (UnknownHostException | SocketException e) {
            e.printStackTrace();
        }

    }

    private void showPopup() {
        AmbilWarnaDialog dialog = new AmbilWarnaDialog(RGBScreen.this, color, true, new AmbilWarnaDialog.OnAmbilWarnaListener() {
            @Override
            public void onOk(AmbilWarnaDialog dialog, int color) {
                try {
                    String hexColor = String.format("#%06X", (0xFFFFFF & color));
                    udp.sendEcho(JSON.getJson("RGB", hexColor));
                    contentView.setBackgroundColor(color);
                } catch (IOException | JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onCancel(AmbilWarnaDialog dialog) {
                Toast.makeText(getApplicationContext(), "Action canceled!", Toast.LENGTH_SHORT).show();
            }
        });
        dialog.show();
    }
}