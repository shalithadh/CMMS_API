using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Authentication.Contracts
{
    public interface IJWTTokenGenerator
    {
        string GenerateUserToken(int UserID, string Username, string Name, int RoleID);
    }
}
