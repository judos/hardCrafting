package missingLocalization;

public class Label {
	public String category;
	public String name;

	public Label(String category, String name) {
		super();
		this.category = category;
		this.name = name;
	}

	@Override
	public String toString() {
		return category + "." + name;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.category == null) ? 0 : this.category.hashCode());
		result = prime * result + ((this.name == null) ? 0 : this.name.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Label other = (Label) obj;
		if (this.category == null) {
			if (other.category != null)
				return false;
		}
		else if (!this.category.equals(other.category))
			return false;
		if (this.name == null) {
			if (other.name != null)
				return false;
		}
		else if (!this.name.equals(other.name))
			return false;
		return true;
	}

}
