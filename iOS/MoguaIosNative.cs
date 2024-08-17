using System.Runtime.InteropServices;
using UnityEngine;

namespace io.mogua.unity
{
#if UNITY_IPHONE
    public class MoguaIosNative : IMoguaNative
    {

        [DllImport("__Internal")]
        private static extern void _GetInstallData();

        public void GetInstallData() {
            _GetInstallData();
        }

        [DllImport("__Internal")]
        private static extern void _GetOpenData();

        public void GetOpenData() {
            _GetOpenData();
        }

    }
#endif
}
