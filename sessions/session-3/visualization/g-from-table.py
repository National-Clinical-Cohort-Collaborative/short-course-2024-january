def g_from_table(pt):
    # This transform closely follow
    #   https://www.palantir.com/docs/foundry/code-workbook/transforms-visualize/#python-visualizations
    # import matplotlib.mlab as mlab
    import matplotlib.pyplot as plt

    INPUT_DF = pt

    SELECTED_COLUMN = "length_of_stay" # Note this should be a numeric column
    NUM_BINS = 30

    # Histogram the selected column
    bins, counts = INPUT_DF.select(SELECTED_COLUMN).rdd.flatMap(lambda x:x).histogram(NUM_BINS)

    # Plot the histogram
    fig, ax = plt.subplots()
    ax.hist(bins[:-1], bins, weights=counts, density=True)

    ax.set_xlabel(SELECTED_COLUMN)
    ax.set_ylabel('Probability density')
    ax.set_title(r'Histogram of ' + str(SELECTED_COLUMN))

    # Tweak spacing to prevent clipping of ylabel
    fig.tight_layout()
    plt.show()
