using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace DonairHubWebApplication.Pages.Shared
{
    public class _MessageModel : PageModel
    {
        [TempData]
        public string Message { get; set; }
        public void OnGet()
        {
        }
    }
}
