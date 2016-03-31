import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import ch.judos.generic.files.config.Config;
import ch.judos.generic.files.config.ConfigSettingsBase;
import ch.judos.generic.files.config.Property;
import ch.judos.generic.files.zip.ZipFile;

public class BuildRelease {

	private Config config;

	public static void main(String[] args) throws IOException {
		new BuildRelease();
	}

	public BuildRelease() throws IOException {
		this.config = new Config(new Properties());

		try {

			String sourceFolder = Properties.sourceFolder.getString();
			String version = getInformation("version", sourceFolder);
			if (version == null) {
				System.out.println("ERROR: version not found in " + sourceFolder
					+ "/info.json");
				return;
			}
			String modName = getInformation("name", sourceFolder);
			String releaseFileName = modName + "_" + version;
			String releaseFolder = Properties.releaseFolder.getString();
			String zipFile = releaseFolder + "/" + releaseFileName + ".zip";

			System.out.println("building release " + version);

			File targetFile = new File(zipFile);
			if (!targetFile.exists()) {
				ZipFile zip = new ZipFile();
				zip.addFolder(new File(sourceFolder), releaseFileName);
				zip.saveZipAs(zipFile);
				System.out.println("Done.");
			}
			else {
				System.out.println("ERROR: File " + zipFile + " exists already");
			}
		}
		finally {
			this.config.save();
		}
	}
	private String getInformation(String propertyName, String srcFolder) throws IOException {
		List<String> lines = Files.readAllLines(Paths.get(srcFolder + "/info.json"));
		String version = null;
		for (String line : lines) {
			if (line.contains(propertyName)) {
				version = line.split(":")[1].replaceAll("[\", ]", "");
				break;
			}
		}
		return version;
	}
	public static class Properties extends ConfigSettingsBase {

		public static Property sourceFolder = new Property("sourceFolder", false, "source");
		public static Property releaseFolder = new Property("releaseFolder", false, "release");
		public static Property modName = new Property("modName", false, "MyMod");

		@Override
		public Object getConfigSettingsObject() {
			return this;
		}

		@Override
		public File getFile() {
			return new File("project-properties.txt");
		}

		@Override
		public boolean isRuntimeNewPropertiesAllowed() {
			return true;
		}

		@Override
		public void save() {
		}

	}
}