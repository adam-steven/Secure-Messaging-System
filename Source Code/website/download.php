<?php
	//retrive the posted file path
	$file_path = $_POST['floaction'];
	

	//split up the paths to get the just file name
	$filename = explode("/", $file_path);
	$filename = $filename[count($filename)-1];

	//check if path exists
	if(file_exists($file_path)) {
		//get the file extention from the name
		$file_extension = strtolower(substr(strrchr($file_path, "."), 1));

		//check the extention is avi
		if($file_extension == "avi")
		{
			//set the Content-Type to the avi setting
			$ctype = "video/x-msvideo";

			//set the Content-Length to the file size
			$filesize = filesize($file_path);

			//append the header information
			header("Content-type: " . $ctype);
			header("Content-Disposition: attachment; filename=\"" . $filename . "\"");
			header("Content-Length: " . $filesize);

			//download the file
			readfile($file_path);
		}
	}
?>