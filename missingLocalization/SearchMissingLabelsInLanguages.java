package missingLocalization;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;

import ch.judos.generic.data.ArraysJS;
import ch.judos.generic.files.FileUtils;

public class SearchMissingLabelsInLanguages {

	public static void main(String[] args) throws IOException {
		new SearchMissingLabelsInLanguages();
	}

	public static String sourceLanguage = "en";
	public static String[] searchLang = {"ru", "zh-CN", "fr"};
	public static String baseLocalePath = "D:/modding/factorio/hardCrafting/source/locale/";
	public static String[] excludedFiles = {"generated.cfg", "generated-2.cfg"};
	public static String outDir = "D:/modding/factorio/hardCrafting/missingLocalization/missingLabelsInLanguages/";

	private ArrayList<Label> existingLabels;
	public SearchMissingLabelsInLanguages() throws IOException {
		indexExistingLabels();
		for (String lang : searchLang) {
			checkAllLabelsExist(lang);
		}
	}

	private void checkAllLabelsExist(String lang) throws IOException {
		HashSet<Label> missingLabel = new HashSet<Label>(this.existingLabels);
		File localeEnDir = new File(baseLocalePath + lang);
		for (File f : (localeEnDir.listFiles((File f, String name) -> !ArraysJS.contains(
			excludedFiles, name)))) {
			LabelReader reader = new LabelReader(f);
			for (Label label : reader) {
				missingLabel.remove(label);
			}
		};
		File file = new File(outDir + lang + ".txt");
		if (missingLabel.size() > 0) {
			System.out.println(lang + ": Found " + missingLabel.size()
				+ " missing labels. See " + lang + ".txt");
			StringBuffer output = new StringBuffer();
			for (Label l : missingLabel) {
				output.append(l + "\n");
			}
			FileUtils.writeToFile(file, output.toString());
		}
		else if (file.exists()) {
			file.delete();
		}
	}

	private void indexExistingLabels() throws IOException {
		this.existingLabels = new ArrayList<Label>();
		File localeEnDir = new File(baseLocalePath + sourceLanguage);
		for (File f : (localeEnDir.listFiles((File f, String name) -> !ArraysJS.contains(
			excludedFiles, name)))) {
			LabelReader reader = new LabelReader(f);
			for (Label label : reader) {
				this.existingLabels.add(label);
			}
		};
	}
}
