using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace DonairHubWebApplication.Pages.Admin
{
    public class LogoutModel : PageModel
    {
        [TempData]
        public string Message { set; get; }
        public async Task<IActionResult> OnPost()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            Message = "You are Logged Out Successfully!";
            return RedirectToAction("/Index");
        }
    }
}
