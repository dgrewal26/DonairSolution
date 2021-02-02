using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using DonairHubWebApplication.Domain;
using DonairHubWebApplication.Helpers;
using DonairHubWebApplication.Technical_Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace DonairHubWebApplication.Pages.Admin
{
    public class LoginModel : PageModel
    {
        [BindProperty]
        [Required(ErrorMessage = "Email Required")]
        public string Username { get; set; }

        [BindProperty, DataType(DataType.Password)]
        [Required, StringLength(25, MinimumLength = 6)]
        public string Password { get; set; }

        [TempData]
        public string Message { get; set; }
        public async Task<IActionResult> OnPost()
        {
            User user = new User();
            Users UserTechnicalServices = new Users();
            user = UserTechnicalServices.GetUser(Username, Password);
            //Login Data
            string UserEmail = user.Email;
            int UserID = user.UserID;
            string UserName = user.FirstName + user.LastName;
            string UserPassword = user.Password;
            string UserRole = user.RoleName;

            HashHelper hash = new HashHelper();
            bool HashedPasswordOutput = hash.CheckMatch(UserPassword, Password);

            if (Username == UserEmail)
            {
                if (HashedPasswordOutput)
                {
                    var claims = new List<Claim>
                    {
                        new Claim(ClaimTypes.Email, UserEmail),
                        new Claim(ClaimTypes.Name, UserName)
                    };
                    var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    claimsIdentity.AddClaim(new Claim(ClaimTypes.Role, UserRole));
                    AuthenticationProperties authenticationProperties = new AuthenticationProperties
                    {
                        IsPersistent = true
                    };
                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(claimsIdentity), authenticationProperties);
                    Message = "You are Logged In Successfully!";
                    return RedirectToPage("/Admin/Index");
                }
            }
            Message = "Invalid attempt";
            return Page();
        }
    }
}

