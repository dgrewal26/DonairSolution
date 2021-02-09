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
    public class Categories
    {
        String connectionString = ConnectionHelper.GetConnectionString();

        //To View all student details    
        public IEnumerable<Category> GetAllCategories()
        {
            List<Category> ctlist = new List<Category>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetAllCategories", con);
                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    Category ct = new Category();
                    ct.CategoryID = Convert.ToInt32(rdr["ID"]);
                    ct.Name = rdr["Name"].ToString();
                    ct.Description = rdr["Description"].ToString();
                    ct.IsDeleted = Convert.ToBoolean(rdr["IsDeleted"]);

                    ctlist.Add(ct);
                }
                con.Close();
            }
            return ctlist;
        }

    }
}
