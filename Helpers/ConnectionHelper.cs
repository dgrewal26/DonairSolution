using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace DonairHubWebApplication.Helpers
{
    public class ConnectionHelper
    {
        public static string GetConnectionString()
        {
            string connectionstring;
            ConfigurationBuilder ABuilder = new ConfigurationBuilder();
            ABuilder.SetBasePath(Directory.GetCurrentDirectory());
            ABuilder.AddJsonFile("appsettings.json");
            IConfiguration AConfiguration = ABuilder.Build();

            string hostcomputername = Environment.GetEnvironmentVariable("COMPUTERNAME");
            if (hostcomputername == "SNEHAL")
            {
                connectionstring = AConfiguration.GetConnectionString("SnehalComputer");
            }
           else if (hostcomputername == "DESKTOP-O5NP4AB")
            {
                connectionstring = AConfiguration.GetConnectionString("DeepComputer");
            }
           else if (hostcomputername == "GROVER")
            {
                connectionstring = AConfiguration.GetConnectionString("GroverComputer");
            }
            else if (hostcomputername == "LAPTOP-LS13V66G")
            {
                connectionstring = AConfiguration.GetConnectionString("HarshComputer");
            }
            else
            {
                connectionstring = AConfiguration.GetConnectionString("Dev1Server");
            }

            return connectionstring;
        }

    }
}
