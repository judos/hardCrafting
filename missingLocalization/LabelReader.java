package missingLocalization;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import ch.judos.generic.data.StringUtils;
import ch.judos.generic.files.FileUtils;

/**
 * @since 11.03.2016
 * @author Julian Schelker
 */
public class LabelReader implements Iterable<Label> {

	private ArrayList<Label> labels;

	public LabelReader(File file) throws IOException {
		this.labels = new ArrayList<Label>();
		indexExistingLabelsForFile(file);
	}

	private void indexExistingLabelsForFile(File f) throws IOException {
		ArrayList<String> lines = FileUtils.readFileContent(f);
		String category = "";
		for (String line : lines) {
			if (line.startsWith("#") || line.equals("")) {
			}
			else if (line.matches("\\[.+\\]"))
				category = StringUtils.substr(line, 1, -1);
			else if (line.contains("=")) {
				String[] x = line.split("=");
				this.labels.add(new Label(category, x[0]));
			}
		}
	}

	@Override
	public Iterator<Label> iterator() {
		return this.labels.iterator();
	}
}
