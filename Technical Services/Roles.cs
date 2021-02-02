using DonairHubWebApplication.Domain;
using DonairHubWebApplication.Helpers;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace DonairHubWebApplication.Technical_Services
{
    public class Roles
    {
        String connectionString = ConnectionHelper.GetConnectionString();
        public IEnumerable<Role> GetAllRoles()
        {
            List<Role> rolelist = new List<Role>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetAllRoles", con);
                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    Role ur = new Role();
                    ur.ID = Convert.ToInt32(rdr["RoleID"]);
                    ur.RoleName = rdr["RoleName"].ToString();
                    ur.Description = rdr["Description"].ToString();
                    rolelist.Add(ur);
                }
                con.Close();
            }
            return rolelist;
        }
    }
}

