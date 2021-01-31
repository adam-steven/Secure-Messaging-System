using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using MySql.Data;
using MySql.Data.MySqlClient;

//handels all message to database data
namespace Doge_Financial
{
    class MessageManagment
    {
        //sends message to the database
        public void SendMessage(string receiverID, string message, bool important, int id)
        {
            //initialize database connection
            string connctionString = DatabaseConnectInfo.connString;
            MySqlConnection conn = new MySqlConnection(connctionString);
            //gets the key assosiated with the user
            string query = "SELECT UniqueIdentifier FROM DOGE_USERS WHERE id = (@value)";

            try
            {
                //start database connection and parameter pass the needed data
                conn.Open();
                MySqlCommand command = new MySqlCommand(query, conn);
                command.Parameters.Add(new MySqlParameter("value", id));
                command.Connection = conn;
                MySqlDataReader dataR = command.ExecuteReader();

                //stores the key
                byte[] userKey = null;
                if (dataR.Read())
                    userKey = (byte[])dataR[0];
                dataR.Close();

                //inserts the message and all needed information to the database
                query = "INSERT INTO DOGE_CONVO (MessageId, SenderId, ReceiverId, Message, ReadMessage, Important, DateStamp, aesiv) VALUES (@MID, @SID, @RID, @message, @RM, @import, @date, @iv)";

                //parameter pass the needed data
                command = new MySqlCommand(query, conn);
                command.Parameters.Add(new MySqlParameter("MID", ""));
                command.Parameters.Add(new MySqlParameter("SID", id));
                command.Parameters.Add(new MySqlParameter("RID", receiverID));
                //encrypts the message before passing
                command.Parameters.Add(new MySqlParameter("message", EncryptionManagment.AESEncrypt(message, userKey)));
                command.Parameters.Add(new MySqlParameter("RM", "1"));
                command.Parameters.Add(new MySqlParameter("import", important));
                command.Parameters.Add(new MySqlParameter("date", DateTime.Now.Year.ToString() + "-" + DateTime.Now.Month.ToString() + "-" + DateTime.Now.Day.ToString()));
                command.Parameters.Add(new MySqlParameter("iv", EncryptionManagment.getIV));

                //closes database connection
                command.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception e)//if a database connection error occurs
            {
                Console.WriteLine(e.Message);
            }

            return;
        }

        public List<string> RetrieveMessage(string receiverID, int id)
        {
            List<string> messages = new List<string>();

            //initialize database connection
            string connctionString = DatabaseConnectInfo.connString;
            MySqlConnection conn = new MySqlConnection(connctionString);
            //get the id and keys from the sender and retrieves id 
            string query = "SELECT id, UniqueIdentifier FROM DOGE_USERS WHERE id = (@value) OR id = (@value2)";

            try
            {
                //start database connection and parameter pass the needed data
                conn.Open();
                MySqlCommand command = new MySqlCommand(query, conn);
                command.Parameters.Add(new MySqlParameter("value", id));
                command.Parameters.Add(new MySqlParameter("value2", receiverID));
                command.Connection = conn;
                MySqlDataReader dataR = command.ExecuteReader();

                //stores the keys
                byte[] userKey = null;
                byte[] receiverKey = null;
                while (dataR.Read())
                {
                    if (dataR[0].ToString() == id.ToString())
                        userKey = (byte[])dataR[1];
                    else
                        receiverKey = (byte[])dataR[1];
                }
                dataR.Close();

                //gets the needes message information from the sender and retriever id
                query = "SELECT Message, SenderId, aesiv FROM DOGE_CONVO WHERE SenderId = (@value) AND ReceiverId = (@value2) OR SenderId = (@value3) AND ReceiverId = (@value4)";
                //parameter pass the needed data
                command = new MySqlCommand(query, conn);
                command.Parameters.Add(new MySqlParameter("value", id));
                command.Parameters.Add(new MySqlParameter("value2", receiverID));
                command.Parameters.Add(new MySqlParameter("value3", receiverID));
                command.Parameters.Add(new MySqlParameter("value4", id));
                command.Connection = conn;
                MySqlDataReader dataRe = command.ExecuteReader();

                //loop to proccess all retrieved database data
                while (dataRe.Read())
                {
                    //if the message id is equal to the users id
                    if (dataRe[1].ToString() == id.ToString())
                    {
                        //decrypts and adds the message to the list 
                        messages.Add("(YOU)  " + EncryptionManagment.DecryptStringFromBytes_Aes((byte[])dataRe[0], userKey, (byte[])dataRe[2]));
                    }
                    else //if the message id is equal to the other accounts id
                    {
                        //decrypts and adds the message to the list 
                        messages.Add("(THEM)  " + EncryptionManagment.DecryptStringFromBytes_Aes((byte[])dataRe[0], receiverKey, (byte[])dataRe[2]));
                    }
                }

                //closes database connection
                dataRe.Close();
                conn.Close();
            }
            catch (Exception e) //if a database connection error occurs
            {
                Console.WriteLine(e.Message);
            }

            return messages;
        }

        //removes the new message and important message indecators 
        public void UpdateNewMessages(string senderID, int itemIndex, int id)
        {
            List<string> messageID = new List<string>();

            //initialize database connection
            string connctionString = DatabaseConnectInfo.connString;
            MySqlConnection conn = new MySqlConnection(connctionString);
            //gets all message ids from the sender and receivers id
            string query = "SELECT MessageId FROM DOGE_CONVO WHERE ReceiverId = (@value) AND SenderId = (@value2) AND ReadMessage = (@value3)";

            try
            {
                //start database connection and parameter pass the needed data
                conn.Open();
                MySqlCommand command = new MySqlCommand(query, conn);
                command.Parameters.Add(new MySqlParameter("value", id));
                command.Parameters.Add(new MySqlParameter("value2", senderID));
                command.Parameters.Add(new MySqlParameter("value3", "1"));
                command.Connection = conn;
                MySqlDataReader dataR = command.ExecuteReader();

                //adds the message ids to the list
                while (dataR.Read())
                {
                    messageID.Add(dataR[0].ToString());
                }

                dataR.Close();

                query = "";
                //loop for all items in the list 
                for (int i = 0; i < messageID.Count; i++)
                {
                    //remove the important and new message indecators 
                    query += "UPDATE DOGE_CONVO SET ReadMessage = 0 AND Important = 0 WHERE MessageId = (@varialbe" + i + ");";
                }

                //loop through and parameter pass the needed data
                command = new MySqlCommand(query, conn);
                for (int i = 0; i < messageID.Count; i++)
                {
                    command.Parameters.Add(new MySqlParameter("varialbe" + i, messageID[i]));
                }

                command.ExecuteNonQuery();

                conn.Close();
            }
            catch (Exception e)  //if a database connection error occurs
            {
                Console.WriteLine(e.Message);
            }

            return;
        }
    }
}
