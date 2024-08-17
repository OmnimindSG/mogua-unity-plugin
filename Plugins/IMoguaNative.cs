using UnityEngine;

namespace io.mogua.unity
{

    interface IMoguaNative
    {

        void GetInstallData();

        void GetOpenData();

    }

    public class MoguaInvalidNative : IMoguaNative
    {

        public void GetInstallData() {
            Debug.Log("Mogua does not support current platform yet.");
        }

        public void GetOpenData() {
            Debug.Log("Mogua does not support current platform yet.");
        }

    }

}
