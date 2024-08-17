using UnityEngine;

namespace io.mogua.unity
{
#if UNITY_ANDROID
    public class MoguaAndroidNative : IMoguaNative
    {

        private AndroidJavaClass javaClass = new AndroidJavaClass("io.mogua.sdk.MoguaUnityCallback");

        public void GetInstallData() {
            javaClass.CallStatic("GetInstallData");
        }

        public void GetOpenData() {
            javaClass.CallStatic("GetOpenData");
        }

    }
#endif
}
