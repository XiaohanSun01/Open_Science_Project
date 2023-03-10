
FROM rocker/r-ver:4.2.0

RUN mkdir /home/analysis

RUN R -e "install.packages('stringr',version='1.5.0')"
RUN R -e "install.packages('purrr',version='1.0.0')"
RUN R -e "install.packages('caret',version='6.0.92')" 
RUN R -e "install.packages('ggplot2',version='3.3.6')" 
RUN R -e "install.packages('randomForest',version='4.7.1.1')"

COPY mushroom_classification.R /home/analysis/mushroom_classification.R
COPY secondary_data_no_miss.csv /home/analysis/secondary_data_no_miss.csv

CMD cd /home/analysis \
  && R -e "source('mushroom_classification.R')" \
  && mv /home/analysis/mushroom_classification_accuracy.txt /home/results/mushroom_classification_accuracy.txt




