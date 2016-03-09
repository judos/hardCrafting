package missingLocalization;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;

import ch.judos.generic.data.DynamicList;
import ch.judos.generic.data.HashMapSet;
import ch.judos.generic.data.StringUtils;
import ch.judos.generic.data.concurrent.ConcurrentIteratorStaticHead;
import ch.judos.generic.files.FileUtils;

public class SearchLocalizedLabels {

	public static void main(String[] args) throws IOException {
		new SearchLocalizedLabels();
	}

	public static final String inputDir = "D:/modding/factorio/hardCrafting/missingLocalization/";
	public static final String inputFile = "hardCrafting-missingRecipeLocalization.txt";
	public static final String searchLocale = "D:/games/Factorio/Factorio_0.12.24 modding/data/base/locale/";
	public static final String output = "D:/modding/factorio/hardCrafting/missingLocalization/out/";

	private ArrayList<MissingLabel> missingLabels;
	private ArrayList<File> languagesPath;
	private HashMapSet<String, String> generatedLines;

	public SearchLocalizedLabels() throws IOException {
		readMissingLabels();
		addMissingLabelDescriptions();
		// readLanguages();
		readFakeLanguage();
		for (File languagePath : languagesPath) {
			searchMissingLabelsInFolder(languagePath);
		}
	}

	private void addMissingLabelDescriptions() {
		ConcurrentIteratorStaticHead<MissingLabel> it = new ConcurrentIteratorStaticHead<>(
			this.missingLabels);
		while (it.hasNext()) {
			MissingLabel element = it.next();
			MissingLabel n = new MissingLabel(element);
			n.targetCategory = n.targetCategory.replace("-name", "-description");
			this.missingLabels.add(n);
		}
	}

	private void searchMissingLabelsInContent(ArrayList<String> content,
		String languageIdentifier) {
		String currentCategory = "";
		MissingLabel l;
		for (String line : content) {
			if (line.equals(""))
				continue;
			else if (line.matches("\\[.+\\]"))
				currentCategory = StringUtils.substr(line, 1, -1);
			else if ((l = getMissingLabel(line, currentCategory)) != null) {
				String[] x = line.split("=");
				this.generatedLines.put(l.targetCategory, l.targetRecipeName + "=" + x[1]);
			}
		}
	}

	private MissingLabel getMissingLabel(String line, String currentCategory) {
		String[] x = line.split("=");
		for (MissingLabel l : this.missingLabels) {
			if (l.sourceName.equals(x[0])
				&& l.targetCategory.equals(mapCategory(currentCategory)))
				return l;
		}
		return null;
	}

	private Object mapCategory(String currentCategory) {
		return currentCategory.replace("item", "recipe").replace("entity", "recipe");
	}

	private void searchMissingLabelsInFolder(File languagePath) throws IOException {
		String languageIdentifier = languagePath.getName();
		File folder = new File(output + languageIdentifier);
		folder.mkdir();
		this.generatedLines = new HashMapSet<String, String>();
		for (File file : languagePath.listFiles()) {
			ArrayList<String> content = FileUtils.readFileContent(file);
			searchMissingLabelsInContent(content, languageIdentifier);
		}
		StringBuffer toWrite = new StringBuffer();
		for (String category : this.generatedLines.keys()) {
			toWrite.append("[" + category + "]\n");
			HashSet<String> entries = this.generatedLines.getSet(category);
			for (String line : entries)
				toWrite.append(line + "\n");
			toWrite.append("\n");
		}

		File generatedLocalization = new File(output + languageIdentifier + "/generated.cfg");
		FileUtils.writeToFile(generatedLocalization, toWrite.toString());
	}

	private void readLanguages() {
		this.languagesPath = new ArrayList<File>();
		File localeFolder = new File(searchLocale);
		new DynamicList<File>(localeFolder.listFiles((File file) -> {
			return file.isDirectory();
		})).forEach((File folder) -> {
			this.languagesPath.add(folder);
		});
	}

	private void readFakeLanguage() {
		this.languagesPath = new ArrayList<File>();
		this.languagesPath.add(new File(searchLocale + "en"));
	}

	private void readMissingLabels() throws IOException {
		this.missingLabels = new ArrayList<MissingLabel>();
		ArrayList<String> lines = FileUtils.readFileContent(new File(inputDir + inputFile));
		for (String line : lines) {
			this.missingLabels.add(new MissingLabel(line));
		}
	}
}
