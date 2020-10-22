package com.example.homeapp.screens;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.an.biometric.BiometricCallback;
import com.an.biometric.BiometricManager;

import com.example.homeapp.R;
import com.example.homeapp.entities.FileAndroid;
import com.example.homeapp.entities.JSON;
import com.example.homeapp.entities.UDP;

import org.json.JSONObject;


public class LoginScreen extends AppCompatActivity implements BiometricCallback {
    private Button button;
    private BiometricManager mBiometricManager;
    private TextView user;
    private TextView pass;
    private RadioButton biometria;
    private JSONObject biometricValue;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_screen);
        user = findViewById(R.id.user);
        pass = findViewById(R.id.pass);
        button = findViewById(R.id.enterLogin);
        biometria = findViewById(R.id.biometria);
        biometricValue = JSON.parseJson(FileAndroid.readFromFile(getApplicationContext()));


        biometria.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(biometricValue.get("cmd")){

                }
            }
        });

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    UDP udp = new UDP();
                    if(udp.sendEcho(JSON.getJson("LOGIN", user.getText().toString() + " " + pass.getText().toString())).equals("PASS")){
                        Intent intent = new Intent(getApplicationContext(), HomeScreen.class);
                        startActivity(intent);
                    } else
                        Toast.makeText(getApplicationContext(), "LOGIN FAILED", Toast.LENGTH_LONG).show();

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

        if(biometricValue){
            mBiometricManager = new BiometricManager.BiometricBuilder(LoginScreen.this)
                    .setTitle("Entrar")
                    .setSubtitle("biometria")
                    .setDescription("Para entrar no aplicativo use a biometria")
                    .setNegativeButtonText("Cancel")
                    .build();

            //start authentication
            mBiometricManager.authenticate(LoginScreen.this);
        }

    }


    @Override
    public void onSdkVersionNotSupported() {
        Toast.makeText(getApplicationContext(), "biometric_error_sdk_not_supported", Toast.LENGTH_LONG).show();
    }

    @Override
    public void onBiometricAuthenticationNotSupported() {
        Toast.makeText(getApplicationContext(), "biometric_error_hardware_not_supported", Toast.LENGTH_LONG).show();
    }

    @Override
    public void onBiometricAuthenticationNotAvailable() {
        Toast.makeText(getApplicationContext(), "biometric_error_fingerprint_not_available", Toast.LENGTH_LONG).show();
    }

    @Override
    public void onBiometricAuthenticationPermissionNotGranted() {
        Toast.makeText(getApplicationContext(), "biometric_error_permission_not_granted", Toast.LENGTH_LONG).show();
    }

    @Override
    public void onBiometricAuthenticationInternalError(String error) {
        Toast.makeText(getApplicationContext(), error, Toast.LENGTH_LONG).show();
    }

    @Override
    public void onAuthenticationFailed() {
//        Toast.makeText(getApplicationContext(), getString(R.string.biometric_failure), Toast.LENGTH_LONG).show();
    }

    @Override
    public void onAuthenticationCancelled() {
        Toast.makeText(getApplicationContext(), "biometric_cancelled", Toast.LENGTH_LONG).show();
        //mBiometricManager..cancelAuthentication();
    }



    @Override
    public void onAuthenticationSuccessful() {
        try {
            Toast.makeText(getApplicationContext(), "biometric_success", Toast.LENGTH_LONG).show();
            Thread.sleep(700);
            Intent intent = new Intent(getApplicationContext(), HomeScreen.class);
            startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onAuthenticationHelp(int helpCode, CharSequence helpString) {
//        Toast.makeText(getApplicationContext(), helpString, Toast.LENGTH_LONG).show();
    }

    @Override
    public void onAuthenticationError(int errorCode, CharSequence errString) {
//        Toast.makeText(getApplicationContext(), errString, Toast.LENGTH_LONG).show();
    }
}