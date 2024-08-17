//
// Created by Mogua.
// Copyright © 2024 Mogua. All rights reserved.
//

package io.mogua.sdk;

import android.content.Intent;
import android.os.Bundle;

import com.unity3d.player.UnityPlayerActivity;

import java.util.Map;

import io.mogua.sdk.Mogua;
import io.mogua.sdk.MoguaUnityCallback;


public class MoguaActivity extends UnityPlayerActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Mogua.init(this, "app_key_placeholder", true);
        Mogua.getInstallData(MoguaUnityCallback.sharedInstallCallbak);
        Mogua.getOpenData(this.getIntent(), MoguaUnityCallback.sharedOpenCallback);
        
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Mogua.getOpenData(intent, MoguaUnityCallback.sharedOpenCallback);
        
    }

}


