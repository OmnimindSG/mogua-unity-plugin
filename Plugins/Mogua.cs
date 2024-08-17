using System;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using UnityEngine;

namespace io.mogua.unity
{

    public class Mogua : MonoBehaviour
    {

        private static Mogua shareInstance;
        private static Action<Dictionary<string, object>> installOnDataAction;
        private static Action<string> installOnErrorAction;
        private static Action<Dictionary<string, object>> openOnDataAction;
        private static Action<string> openOnErrorAction;

        private IMoguaNative moguaNative;

        private void Awake()
        {
            if (shareInstance != null)
            {
                Destroy(shareInstance);
            }
            shareInstance = this;
#if UNITY_ANDROID
            moguaNative = new MoguaAndroidNative();
#elif UNITY_IPHONE
            moguaNative = new MoguaIosNative();
#else
            moguaNative = new MoguaInvalidNative();
#endif
            DontDestroyOnLoad(shareInstance);
        }

        public void GetInstallData(Action<Dictionary<string, object>> onData, Action<string> onError)
        {
            installOnDataAction = onData;
            installOnErrorAction = onError;
            moguaNative.GetInstallData();
        }

        public void GetOpenData(Action<Dictionary<string, object>> onData, Action<string> onError)
        {
            openOnDataAction = onData;
            openOnErrorAction = onError;
            moguaNative.GetOpenData();
        }

        private void InstallOnData(string str)
        {
            if (installOnDataAction is null) return;
            Dictionary<string, object> dict = Utils.queryParametersToDictionary(str);
            installOnDataAction(dict);
        }


        private void InstallOnError(string str)
        {
            if (installOnErrorAction is null) return;
            installOnErrorAction(str);
        }

        private void OpenOnData(string str)
        {
            if (openOnDataAction is null) return;
            Dictionary<string, object> dict = Utils.queryParametersToDictionary(str);
            openOnDataAction(dict);
        }

        private void OpenOnError(string str)
        {
            if (openOnErrorAction is null) return;
            openOnErrorAction(str);
        }

    }

    class Utils
    {

        static public Dictionary<string, object> queryParametersToDictionary(string qps)
        {
            var output = new Dictionary<string, object>();
            var items = qps.Split('&', StringSplitOptions.RemoveEmptyEntries);
            foreach (var item in items)
            {
                var kvp = item.Split('=');
                if (kvp.Length != 2) continue;
                var keyDecode = HttpUtility.UrlDecode(kvp[0]);
                var valueDecode = HttpUtility.UrlDecode(kvp[1]);
                output[keyDecode] = valueDecode;
            }
            return output;
        }

    }

}
