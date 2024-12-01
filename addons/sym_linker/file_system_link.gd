class_name SymLinkerFileSystemLink
extends RefCounted


# https://github.com/godot-extended-libraries/godot-next/blob/master/addons/godot-next/global/file_system_link.gd


static func mk_soft_dir(p_target: String, p_linkpath: String = "") -> Error:
	var params: Array[String] = []
	var output := []
	var target := ProjectSettings.globalize_path(p_target)
	var linkpath := ProjectSettings.globalize_path(p_linkpath)

	if not DirAccess.dir_exists_absolute(target):
		return ERR_FILE_NOT_FOUND

	match OS.get_name():
		"Windows":
			params = [
				"-command New-Item -Path",
				linkpath,
				"-ItemType",
				"SymbolicLink",
				"-value",
				target,
				"-name",
				target.get_file(),

			]
			OS.execute("powershell.exe", ["-command", "Start-Process -FilePath \"powershell\" -Verb RunAs -ArgumentList '%s'" % " ".join(params)], output)
			return OK

		"X11", "OSX", "LinuxBSD":
			params = [
				"-s",
				target,
				linkpath,
			]
			OS.execute("ln", params, output)
			return OK
		_:
			return ERR_UNAVAILABLE
