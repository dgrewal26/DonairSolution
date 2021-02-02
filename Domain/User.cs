using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace DonairHubWebApplication.Domain
{
    public class User
    {
        public int UserID { get; set; }
        [Required, MaxLength(10)]
        public string FirstName { get; set; }
        [Required, MaxLength(10)]
        public string LastName { get; set; }
        public string Password { get; set; }
        [Required, EmailAddress]
        public string Email { get; set; }
        public int RoleID { get; set; }
        public string RoleName { get; set; }
    }
}
