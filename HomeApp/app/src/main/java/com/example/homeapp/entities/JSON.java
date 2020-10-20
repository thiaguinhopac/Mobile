package com.example.homeapp.entities;

import org.json.JSONException;
import org.json.JSONObject;

public class JSON {
    public static String getJson(String cmd, String data) throws JSONException {
        JSONObject my_obj = new JSONObject();
        my_obj.put("cmd",cmd);
        my_obj.put("data", data);
        return my_obj.toString();
    }
}
