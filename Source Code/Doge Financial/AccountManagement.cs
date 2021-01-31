using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MySql.Data;
using MySql.Data.MySqlClient;

//retrieves the need information of other accounts
namespace Doge_Financial
{
    class AccountManagement
    {
        //initializes global list variables
        private static Tuple<List<string>, List<string>, List<bool>> listAccounts;
        private List<string> newMessages = new List<string>();
        private List<string> importantMessages = new List<string>();

        //send the account information to the repository
        public static Tuple<List<string>, List<string>, List<bool>> getAccounts
        {
            get { return listAccounts; }
        }

        //gets all other accounts and other needed account information to send to the repository 
        public void GetOtherUsers(int id)
        {
            //initialize local lists to create the global tuple "listAccounts"
            List<string> accounts = new List<string>();
            List<string> accountsID = new List<string>();
            List<bool> accountsNM = new List<bool>();

            //call functions, to get the new and important messages from the database 
            NewMessagesCheck(id);
            ImportantMessagesCheck(id);

            //initialize database connection
            string connctionString = DatabaseConnectInfo.connString;
            MySqlConnection conn = new MySqlConnection(connctionString);
            //query to get all accounts other than the user
            string query = "SELECT id, Username FROM DOGE_USERS WHERE id <> (@value)";

            try
            {
                //start database connection and parameter pass the needed data
                conn.Open();
                MySqlCommand command = new MySqlCommand(query, conn);
                command.Parameters.Add(new MySqlParameter("value", id));
                command.Connection = conn;
                MySqlDataReader dataR = command.ExecuteReader();

                //loop to proccess all retrieved database data
                while (dataR.Read())
                {
                    //checks if account has a new message
                    if (newMessages.Contains(dataR[0].ToString()))
                    {
                        //checks if account has an important message
                        if (importantMessages.Contains(dataR[0].ToString()))
                        {
                            //adds the account name to the start of the list
                            accounts.Insert(0, dataR[1].ToString() + " (IMPORTANT)");

                            //creates audiable beep for important messages
                            int frequency = 600;
                            int duration = 100;
                            Console.Beep(frequency, duration);
                            int frequency2 = 800;
                            int duration2 = 100;
                            Console.Beep(frequency2, duration2);
                        }
                        else //if the message is not important
                        {
                            //adds the account name to the start of the list
                            accounts.Insert(0, dataR[1].ToString() + " (NEW)");
                        }

                        //adds the account id and new message bool to the start of the list
                        accountsID.Insert(0, dataR[0].ToString());
                        accountsNM.Add(true);

                    }
                    else //if the account has no important or new messages
                    {
                        //adds the account name, id and new message bool to the end of the list
                        accounts.Add(dataR[1].ToString());
                        accountsID.Add(dataR[0].ToString());
                        accountsNM.Add(false);
                    }

                }

                //closes database connection
                dataR.Close();
                conn.Close();
            }
            catch (Exception e)//if a database connection error occurs
            {
                Console.WriteLine(e.Message);
            }

            //creates the tuple from the local lists
            listAccounts = Tuple.Create(accounts, accountsID, accountsNM);

            return;
        }

        //retrieves all new messages from the database
        public void NewMessagesCheck(int id)
        {
            //initialize database connection
            string connctionString = DatabaseConnectInfo.connString;
            MySqlConnection conn = new MySqlConnection(connctionString);
            //query to get all message that have the user as a reciever and the message has not been read 
            string query = "SELECT * FROM DOGE_CONVO WHERE ReceiverId = (@value) AND ReadMessage = (@value2) ";

            try
            {
                //start database connection and parameter pass the needed data
                conn.Open();
                MySqlCommand command = new MySqlCommand(query, conn);
                command.Parameters.Add(new MySqlParameter("value", id));
                command.Parameters.Add(new MySqlParameter("value2", "1"));
                command.Connection = conn;
                MySqlDataReader dataR = command.ExecuteReader();

                //stores all retrieved data in a list
                while (dataR.Read())
                {
                    newMessages.Add(dataR[1].ToString());
                }

                //closes database connection
                dataR.Close();
                conn.Close();
            }
            catch (Exception e) //if a database connection error occurs
            {
                Console.WriteLine(e.Message);
            }

            return;
        }

        public void ImportantMessagesCheck(int id)
        {
            //initialize database connection
            string connctionString = DatabaseConnectInfo.connString;
            MySqlConnection conn = new MySqlConnection(connctionString);
            //query to get all message that have the user as a reciever and the message is important
            string query = "SELECT * FROM DOGE_CONVO WHERE ReceiverId = (@value) AND Important = (@value2) ";

            try
            {
                //start database connection and parameter pass the needed data
                conn.Open();
                MySqlCommand command = new MySqlCommand(query, conn);
                command.Parameters.Add(new MySqlParameter("value", id));
                command.Parameters.Add(new MySqlParameter("value2", "1"));
                command.Connection = conn;
                MySqlDataReader dataR = command.ExecuteReader();

                //stores all retrieved data in a list
                while (dataR.Read())
                {
                    importantMessages.Add(dataR[1].ToString());
                }

                //closes database connection
                dataR.Close();
                conn.Close();
            }
            catch (Exception e) //if a database connection error occurs
            {
                Console.WriteLine(e.Message);
            }

            return;
        }
    }
}
