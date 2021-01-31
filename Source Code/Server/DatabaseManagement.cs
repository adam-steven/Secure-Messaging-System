using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MySql.Data;
using MySql.Data.MySqlClient;

//uses MySql and MySqlBackup

//delecte all messages older than six months from the server and backup of the server
namespace Server
{
    class DatabaseManagement
    {
        //delecte all messages older than six months
        public void DatabaseClear()
        {
            //initialize database connection
            string connctionString = DatabaseConnectInfo.connString;
            MySqlConnection conn = new MySqlConnection(connctionString);
            //delecte all messages older than six months
            string query = "DELETE FROM DOGE_CONVO WHERE DateStamp < DATE_SUB(NOW(), INTERVAL 6 MONTH)";

            try
            {
                //start database connection
                conn.Open();
                MySqlCommand command = new MySqlCommand(query, conn);

                command.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception e) //if a database connection error occurs
            {
                Console.WriteLine(e.Message);
            }

            return;
        }

        //backup the database
        public void Backup()
        {
            string connctionString = DatabaseConnectInfo.connString;
            string file = "backup.sql";
            using (MySqlConnection conn = new MySqlConnection(connctionString))
            {
                using (MySqlCommand cmd = new MySqlCommand())
                {
                    using (MySqlBackup mb = new MySqlBackup(cmd))
                    {
                        cmd.Connection = conn;
                        conn.Open();
                        mb.ExportToFile(file);
                        conn.Close();
                    }
                }
            }
        }

        //restore the database from the backup
        public void Restore()
        {
            string connctionString = DatabaseConnectInfo.connString;
            string file = "backup.sql";
            using (MySqlConnection conn = new MySqlConnection(connctionString))
            {
                using (MySqlCommand cmd = new MySqlCommand())
                {
                    using (MySqlBackup mb = new MySqlBackup(cmd))
                    {
                        cmd.Connection = conn;
                        conn.Open();
                        mb.ImportFromFile(file);
                        conn.Close();
                    }
                }
            }
        }
    }
}
