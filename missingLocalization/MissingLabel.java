package missingLocalization;

import java.util.Arrays;

public class MissingLabel {
	public String targetRecipeName;
	public String targetCategory;
	public String sourceName;

	public MissingLabel(String line) {
		String[] x = line.split(",");
		if (!(x.length == 2))
			throw new IllegalArgumentException("only one comma allowed in line parameter: "
				+ line);
		this.targetRecipeName = x[0];
		String[] y = x[1].split("\\.");
		if (!(y.length == 2))
			throw new IllegalArgumentException("only one point allowed in line parameter: "
				+ line + "\n " + x[1] + " was split into: " + Arrays.toString(y));
		this.sourceName = y[1];
		this.targetCategory = "recipe-name";
	}

	public MissingLabel(MissingLabel element) {
		this.targetRecipeName = element.targetRecipeName;
		this.sourceName = element.sourceName;
		this.targetCategory = element.targetCategory;
	}

	@Override
	public String toString() {
		return this.targetCategory + " " + this.targetRecipeName + " - " + this.sourceName;
	}
}
