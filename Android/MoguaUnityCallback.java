//
// Created by Mogua.
// Copyright © 2024 Mogua. All rights reserved.
//

package io.mogua.sdk;

import com.unity3d.player.UnityPlayer;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Map;

import io.mogua.sdk.MoguaCallback;


public class MoguaUnityCallback implements MoguaCallback  {

    private static final String UnityObject = "Mogua";

    private final String _onDataMethod;
    private final String _onErrorMethod;
    private boolean _readyToSend;
    private Map<String, Object> _pendingData;
    private Exception _pendingError;

    private MoguaUnityCallback(String onDataMethod, String onErrorMethod) {
        _onDataMethod = onDataMethod;
        _onErrorMethod = onErrorMethod;
        _readyToSend = false;
    }

    @Override
    public void onData(Map<String, Object> data) {
        if (_readyToSend) {
            sendDataMessage(data);
        } else {
            _pendingData = data;
        }
    }

    @Override
    public void onError(Exception e) {
        if (_readyToSend) {
            sendErrorMessage(e);
        } else {
            _pendingError = e;
        }
    }

    private static String dictionaryToQueryParameters(Map<String, Object> dict) {
        ArrayList<String> items = new ArrayList<>();
        for (String key : dict.keySet()) {
            Object value = dict.get(key);
            if (value == null) continue;
            try {
                String encodedKey = URLEncoder.encode(key, "UTF-8");
                String encodedValue = URLEncoder.encode(value.toString(), "UTF-8");
                String item = encodedKey + "=" + encodedValue;
                items.add(item);    
            } catch (Exception e) {
                continue;
            }
        }
        return String.join("&", items);
    }

    private void sendDataMessage(Map<String, Object> data) {
        String queryParameters = dictionaryToQueryParameters(data);
        UnityPlayer.UnitySendMessage(UnityObject, _onDataMethod, queryParameters);
    }

    private void sendErrorMessage(Exception e) {
        UnityPlayer.UnitySendMessage(UnityObject, _onErrorMethod, e.getLocalizedMessage());
    }

    private void sendPendingMessage() {
        if (_pendingData != null) {
            sendDataMessage(_pendingData);
            _pendingData = null;
        } else if (_pendingError != null) {
            sendErrorMessage(_pendingError);
            _pendingError = null;
        }
    }

    public static MoguaUnityCallback sharedInstallCallbak = new MoguaUnityCallback("InstallOnData", "InstallOnError");

    private static void GetInstallData() {
        sharedInstallCallbak._readyToSend = true;
        sharedInstallCallbak.sendPendingMessage();
    }

    public static MoguaUnityCallback sharedOpenCallback = new MoguaUnityCallback("OpenOnData", "OpenOnError");

    private static void GetOpenData() {
        sharedOpenCallback._readyToSend = true;
        sharedOpenCallback.sendPendingMessage();
    }

}


