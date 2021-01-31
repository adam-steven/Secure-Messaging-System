using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MySql.Data;
using MySql.Data.MySqlClient;

//handles the users credentials 
namespace Doge_Financial
{
    class IdentityManagement
    {
        private static int id = -1;

        //send the users id to the repository
        public static int getID
        {
            get { return id; }
        }

        //validate login
        public bool ValidateLogin(string username, string password)
        {
            bool validationResult = false;

            //initialize database connection
            string connctionString = DatabaseConnectInfo.connString;
            MySqlConnection conn = new MySqlConnection(connctionString);
            //gets the users id, encrypted password, key and iv given the username
            string query = "SELECT DOGE_USERS.id, DOGE_USERS.Password, DOGE_USER_SECURITY.passKey, DOGE_USER_SECURITY.passIV FROM DOGE_USERS, DOGE_USER_SECURITY WHERE DOGE_USERS.Username = (@value) AND DOGE_USER_SECURITY.userID = DOGE_USERS.id";

            try
            {
                //start database connection and parameter pass the needed data
                conn.Open();
                MySqlCommand command = new MySqlCommand(query, conn);
                command.Parameters.Add(new MySqlParameter("value", username));
                command.Connection = conn;
                MySqlDataReader dataR = command.ExecuteReader();
                //if there is a file add it to the static variables
                while (dataR.Read())
                {
                    //check if the password is correct
                    if (EncryptionManagment.DecryptStringFromBytes_Aes((byte[])dataR[1], (byte[])dataR[2], (byte[])dataR[3]) == password)
                    {
                        //store id
                        validationResult = true;
                        id = int.Parse(dataR[0].ToString());
                    }
                }

                //closes database connection
                dataR.Close();
                conn.Close();
            }
            catch (Exception e) //if a database connection error occurs
            {
                Console.WriteLine(e.Message);
            }

            return validationResult;
        }

        //remove stored user id
        public void Logout()
        {
            id = -1;
        }
    }
}
