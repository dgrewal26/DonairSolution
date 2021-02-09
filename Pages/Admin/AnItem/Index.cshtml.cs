using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using DonairHubWebApplication.Domain;
using DonairHubWebApplication.Technical_Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace DonairHubWebApplication.Pages.Admin.AnItem
{
    public class IndexModel : PageModel
    {
        Items objitm = new Items();
        public List<Item> item { get; set; }

        [BindProperty]
        [Required]
        public string ItemID { get; set; }

        [TempData]
        public string Message { get; set; }

        public void OnGet()
        {
                    item = objitm.GetAnItems().ToList();
        }

    }
}

