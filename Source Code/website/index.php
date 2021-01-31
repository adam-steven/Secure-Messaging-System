<?php
		//start, reset and destroy any existing sessions
        session_start();
        $_SESSION = array();
        session_destroy();
?>

<!DOCTYPE html>
<htlm>
	<head>
		<title>Tracking Cam</title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
	</head>
	<body>
		<div class='container-fluid'>
			<br>
			<div class='row'>
				<div class='col-sm-2'> </div>

				<div class='col-sm-8'>
					<div class="card">
						<div class="card-body">
							<h4 class="card-title">Login</h4>
							<p class="card-text">
								<?php
									if(isset($_GET["error"])){
										$errorNum = $_GET["error"];
										
										switch ($errorNum) {
											case "011":
												echo "<p>Error: Incorrectly Login Information.</p>";
												break;
										}
									}
								?>
								<form name="login" method="post" action="loginValidation.php">
									
									<div class="form-group">
										<label for="uname">User:</label>
										<input name="uname" type="text" class="form-control" placeholder="Enter username" id="uname"/>
									</div>
									<div class="form-group">
										<label for="pwd">Password:</label>
										<input name="pwd" type="password" class="form-control" placeholder="Enter password" id="pwd"/>
									</div>
									<button class="button" type="submit" >Submit</button>
									
								</form>
							</p>
						</div>
					</div>
				</div>
				
				<div class='col-sm-2'> </div>
			</div>
		</div>
	</body>
</html>