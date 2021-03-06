using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using DonairHubWebApplication.Domain;
using DonairHubWebApplication.Technical_Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace DonairHubWebApplication.Pages.Admin.ACategory
{
    public class IndexModel : PageModel
    {
        Categories objct = new Categories();
        public List<Category> category { get; set; }

        [BindProperty]
        [Required]
        public string CategoryID { get; set; }

        [TempData]
        public string Message { get; set; }

        public void OnGet()
        {
            category = objct.GetAllCategories().ToList();
        }
    }
}
