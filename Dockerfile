
FROM rocker/r-ver:4.2.0

RUN mkdir /home/analysis

RUN R -e "install.packages('stringr')"
RUN R -e "install.packages('purrr')"
RUN R -e "install.packages('caret')" 
RUN R -e "install.packages('ggplot2')" 
RUN R -e "install.packages('randomForest')" 

COPY mushroom_classification.R /home/analysis/mushroom_classification.R
COPY secondary_data_no_miss.csv /home/analysis/secondary_data_no_miss.csv

CMD cd /home/analysis \
  && R -e "source('mushroom_classification.R')" \
  && mv /home/analysis/mushroom_classification_accuracy.txt /home/results/mushroom_classification_accuracy.txt

