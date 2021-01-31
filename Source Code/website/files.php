<?php 
	session_start();
	
	//check the user is logged in
	if(!isset($_SESSION['cmp408Access']) || $_SESSION['cmp408Access'] != 'adam')
		header("location: index.php");
?>

<!DOCTYPE html>
<html>
	<head>
		<title>Tracking Cam</title>
		
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>

		<style>
			table {
			  font-family: arial, sans-serif;
			  border-collapse: collapse;
			  width: 100%;
			}

			td, th {
			  border: 1px solid #dddddd;
			  text-align: center;
			  padding: 8px;
			}

			tr:nth-child(even) {
			  background-color: #dddddd;
			}
		</style>

	</head>
	<body>
		<table>
			<tr>
				<th>Date</th>
				<th>File</th>
				<th>Open</th>
			</tr>
	
			<?php
				//get all .avi file paths from the local "videos" folder
				$images = glob('vidoes/*.avi'); 
				
				//loop through the retrived path
				foreach ($images as $location) {
					//split up the paths to get the just file name
					$filename = explode("/", $location);
					$filename = $filename[count($filename)-1];
					
					//display the files HTML information
					echo "
					<tr>
						<td>".date("F d Y H:i:s.", filemtime($location))."</td>
						<td>".$filename."</td>
						<td>
							<form action='download.php' method='post'>
								<input type='hidden' id='floaction' name='floaction' value='".$location."'>
								<button>DOWNLOAD</button>
							</form>
						</td>
					</tr>";
				}
			?>
		
		</table>
	</body>

</html>
