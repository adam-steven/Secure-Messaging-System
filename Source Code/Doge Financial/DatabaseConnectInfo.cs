using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Doge_Financial
{
    class DatabaseConnectInfo
    {
        private static string connctionString = "Data Source = ;Initial Catalog = ;User ID = ;Password = ";

        public static string connString
        {
            get { return connctionString; }
        }
    }
}
