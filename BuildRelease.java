import java.io.File;
import java.io.IOException;

import ch.judos.generic.files.config.Config;
import ch.judos.generic.files.config.ConfigSettingsBase;
import ch.judos.generic.files.config.Property;
import ch.judos.generic.files.zip.ZipUtils;

public class BuildRelease {

	private Config config;

	public static void main(String[] args) throws IOException {
		new BuildRelease();
	}

	public BuildRelease() throws IOException {
		this.config = new Config(new Properties());
		Property version = this.config.getPropertyByName("version");
		System.out.println("building release " + version.getString());

		Property releaseFileName = this.config.getPropertyByName("destinationName");
		String zipName = releaseFileName + "_" + version + ".zip";
		System.out.println("creating zip-file: " + zipName);

		String sourceFolder = this.config.getPropertyByName("sourceFolder").getString();
		ZipUtils.pack(sourceFolder, zipName);
	}

	public static class Properties extends ConfigSettingsBase {

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