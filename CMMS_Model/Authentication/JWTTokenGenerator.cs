using CMMS_Model.Authentication.Contracts;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace CMMS_Model.Authentication
{
    public class JWTTokenGenerator: IJWTTokenGenerator
    {
        public string GenerateUserToken(int UserID, string Username, string Name, int RoleID) {

            //Claims
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, UserID.ToString()),
                new Claim(ClaimTypes.Name, UserID.ToString()),
                new Claim("UserID", UserID.ToString()),
                new Claim("Username", Username),
                new Claim("Name", Name),
                new Claim(ClaimTypes.Role, RoleID.ToString()),
                new Claim("RoleID", RoleID.ToString())
            };

            var keyBytes = Encoding.UTF8.GetBytes(Constants.Secret);

            var key = new SymmetricSecurityKey(keyBytes);

            var signingCredentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                Constants.Audience,
                Constants.Issuer,
                claims,
                notBefore: DateTime.Now,
                //expires: DateTime.Now.AddHours(1), //1 hour
                expires: DateTime.Now.AddHours(12), //12 hour
                signingCredentials
             );

            var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

            return tokenString;
        }
    }
}
