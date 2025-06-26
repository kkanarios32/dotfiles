#!./.venv/bin/python3

import argparse
from io import StringIO
from sys import stdin

import pandas as pd  # type: ignore [import]
import seaborn as sns
import matplotlib.pyplot as plt


def read_blank_separated(f):
    return filter(None, (s.strip("\n") for s in f.read().split("\n\n")))


def read_csv(inp):
    def convert_time(t):
        if t.isdigit():
            return pd.to_timedelta(int(t), unit="s")
        else:
            return pd.to_timedelta(t)

    return pd.read_csv(
        StringIO(inp),
        index_col="Tag",
        usecols=["Tag", "Time"],
        converters={"Time": convert_time},
    )


def has_meaningful_data(table):
    total = table["Time"].sum()
    return not table.empty and not pd.isna(total) and total.total_seconds() > 0


def extract_category(table):
    [category] = table.index.str.extract(r"^([\w-]+):", expand=False).dropna().unique()
    prefix = category + ":"
    return category, table.rename(
        lambda s: s[len(prefix) if s.startswith(prefix) else 0 :]
    )


def load_inputs(csvs):
    inputs = {}
    for csv in csvs:
        table = read_csv(csv)
        if not has_meaningful_data(table):
            continue

        category, table = extract_category(table)
        if category in inputs:
            inputs[category] = inputs[category].add(table, fill_value=pd.Timedelta(0))
        else:
            inputs[category] = table

    return inputs


def preprocess(inputs):
    df = pd.concat(
        inputs.values(),  # list of DataFrames
        keys=inputs.keys(),  # outer index = category
        names=["Category", "Tag"],  # name the index levels
    )
    df = df[
        ~df.index.get_level_values("Tag").str.fullmatch(r"\(unmatched time\)")
        & ~df.index.get_level_values("Tag").str.fullmatch(r"\(1 entries omitted\)")
        & ~df.index.get_level_values("Tag").str.fullmatch(r"\(total time\)")
    ]
    df["Hours"] = pd.to_timedelta(df["Time"]).dt.total_seconds() / 3600
    return df


def fmt_time(td):
    return strfdelta(td, "{hours:02}:{minutes:02}:{seconds:02}")


def strfdelta(tdelta, fmt):
    tdelta = tdelta.to_pytimedelta()
    d = {}
    d["hours"], rem = divmod(tdelta.seconds, 3600)
    d["hours"] += 24 * tdelta.days
    d["minutes"], d["seconds"] = divmod(rem, 60)
    return fmt.format(**d)


def parse_cmdline_args(*args) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="""
        Plot charts from arbtt-stats to terminal.
        Expects `arbtt-stats --output-format=csv --category=…` or
        `arbtt-stats --output-format=csv --each-category` output on stdin.
        """,
    )
    parser.add_argument(
        "--no-stacked",
        dest="stacked",
        action="store_false",
        help="don't stack bar chart",
    )
    parser.add_argument(
        "--subtags",
        dest="subtags",
        action="store_true",
        help="recognize subtags (separated by '-') and sort them together",
    )
    totals_re_default = r"^\(total time\)$"
    parser.add_argument(
        "--totals-re",
        dest="totals_re",
        default=totals_re_default,
        help=f"totals row regexp, default: {totals_re_default}",
        metavar="RE",
    )
    return parser.parse_args(*args)


def plot(df):
    plot_df = df[df["Type"] == "bar"].copy()
    plot_df["Hours"] = pd.to_timedelta(plot_df["Time"]).dt.total_seconds() / 3600
    print(plot_df)


def set_style():
    sns.set_context("paper", font_scale=1.5)
    rc = {
        "font.family": "sans-serif",
        "font.sans-serif": "Work Sans",
        "axes.spines.top": False,
        "axes.spines.right": False,
        "axes.labelsize": 14,
        "axes.titlesize": 16,
        "axes.titleweight": 300,
        "axes.labelweight": 400,
        "legend.fontsize": 12,
        "xtick.labelsize": 12,
        "ytick.labelsize": 12,
        "figure.dpi": 300,
        "savefig.bbox": "tight",
    }
    palette = sns.color_palette("ch:start=.2,rot=-.3")
    sns.set_theme(palette=palette, style="whitegrid", rc=rc)


def by_category(df, category):
    cat_df = df.loc[category]

    set_style()
    sns.barplot(cat_df, x="Tag", y="Hours")

    plt.title(category, fontstyle="italic")
    plt.tight_layout()
    plt.show()


def summary(df):
    df = df[df.index.get_level_values("Category") != "Program"].copy()
    # df = df[df["Hours"] >= 0.3]

    set_style()

    plt.figure(figsize=(14, 6))  # wider and taller
    sns.barplot(df, y="Tag", x="Hours", hue="Category")

    # plt.xticks(rotation=45)  # or 60, or 90 if needed
    plt.title("Summary", fontstyle="italic")
    plt.tight_layout()
    plt.show()


def main() -> None:
    args = parse_cmdline_args()

    inputs = load_inputs(read_blank_separated(stdin))
    if not inputs:
        return print("(no meaningful inputs)")
    df = preprocess(inputs)
    summary(df)
    by_category(df, "Personal")


if __name__ == "__main__":
    main()
