<?php
        session_start();

        $data = new \stdClass();
		
		//get the posted data and store in the data class
        foreach ($_POST as $key => $value) {
                $data -> $key = $value;
        }
		
		//for prototype purposes the loggin info is added here (default php password encryption settings)
        $user = 'adam';
        $pass = '$2y$10$yFuQ/kRb6VjlPGQErgVhEel.NQNbZc.5j63e5wGM4K41lUbjSqtUe';

		//check the sent cradentials are correct
        if(($data -> uname == $user) && password_verify($data -> pwd, $pass))
        {
				//set the session and redirect the user
                $_SESSION['cmp408Access'] = $user;
                header("location: files.php");
        }
        else
				//kick the use back to login
				//error 011 = fields login details. (system used since CMP204)
                header("location: index.php?error=011"); 
?>


