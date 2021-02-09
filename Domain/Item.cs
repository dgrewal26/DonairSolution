using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace DonairHubWebApplication.Domain
{
    public class Item
    {
        public int ItemID { get; set; }
        public int CategoryID { get; set; }
        [Required]
        public string ItemName { get; set; }
        [Required]
        public string Description { get; set; }
        [Required]
        [RegularExpression("([1-9][0-9]*.?[0-9]*)", ErrorMessage = "UnitPrice must be a positive number")]
        public decimal UnitPrice { get; set; }
        [Required]
        public IFormFile OriginalImage { get; set; }
        public string Image { get; set; }
        public string CategoryName { get; set; }
        public string CategoryDescription { get; set; }
        public bool IsDeleted { get; set; }
    }
}
