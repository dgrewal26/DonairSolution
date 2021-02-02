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
    public class Users
    {
        String connectionString = ConnectionHelper.GetConnectionString();
        public User GetUser(string Email, string Password)
        {
            User ur = new User();
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetUser", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Email", Email);
                cmd.Parameters.AddWithValue("@Password", Password);

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    ur.RoleID = Convert.ToInt32(rdr["RoleID"]);
                    ur.UserID = Convert.ToInt32(rdr["ID"]);
                    ur.FirstName = rdr["FirstName"].ToString();
                    ur.LastName = rdr["LastName"].ToString();
                    ur.Email = rdr["Email"].ToString();
                    ur.Password = rdr["Password"].ToString();
                    ur.RoleName = rdr["RoleName"].ToString();
                }
                con.Close();
            }
            return ur;
        }

    }
}

