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
    public class Items
    {
        String connectionString = ConnectionHelper.GetConnectionString();

        //To View all student details    
        public IEnumerable<Item> GetAnItems()
        {
            List<Item> Itemlist = new List<Item>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("GetAllItems", con);
                cmd.CommandType = CommandType.StoredProcedure;

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();

                while (rdr.Read())
                {
                    Item itm = new Item();
                    itm.ItemID = Convert.ToInt32(rdr["ItemID"]);
                    itm.CategoryID = Convert.ToInt32(rdr["CategoryID"]);
                    itm.ItemName = rdr["ItemName"].ToString();
                    itm.Description = rdr["ItemDescription"].ToString();
                    itm.CategoryName = rdr["CategoryName"].ToString();
                    itm.UnitPrice = Convert.ToDecimal(rdr["UnitPrice"]);
                    itm.IsDeleted = Convert.ToBoolean(rdr["IsDeleted"]);

                    Itemlist.Add(itm);
                }
                con.Close();
            }
            return Itemlist;
        }

        internal object FindAnItem(int i)
        {
            throw new NotImplementedException();
        }
    }
}
