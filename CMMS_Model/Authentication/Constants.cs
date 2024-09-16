using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Authentication
{
    public static class Constants
    {
        //For JWT
        public const string Audience = "https://localhost:7129";
        public const string Issuer = "https://localhost:7129";
        public const string Secret = "JWgd$28otyQnfHcPyh81KoR1cJUV8indTRt45@%rt#";

        //For AES Operation
        public const string AESCustomKey = "o5aK$oDvG8e$fH@4KPapJ%Cw0JhUO@2l"; //32 Characters long

    }
}
