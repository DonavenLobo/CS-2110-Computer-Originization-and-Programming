/**
 * @file hw7.c
 * @author	Donaven Lobo
 * @collaborators NAMES OF PEOPLE THAT YOU COLLABORATED WITH HERE
 * @brief structs, pointers, pointer arithmetic, arrays, strings, and macros
 * @date 2022-03-xx
 */

// DO NOT MODIFY THE INCLUDE(S) LIST
#include <stdio.h>
#include "hw7.h"
#include "my_string.h"

// Global array of Animal structs
struct animal animals[MAX_ANIMAL_LENGTH];

int size = 0;

/** addAnimal
 *
 * @brief creates a new Animal and adds it to the array of Animal structs, "animals"
 *
 *
 * @param "species" species of the animal being created and added
 *               NOTE: if the length of the species (including the null terminating character)
 *               is above MAX_SPECIES_LENGTH, truncate species to MAX_SPECIES_LENGTH. If the length
 *               is 0, return FAILURE.  
 *               
 * @param "id" id of the animal being created and added
 * @param "hungerScale" hunger scale of the animal being created and added
 * @param "habitat" habitat of the animal being created and added
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) "species" length is 0
 *         (2) "habitat" length is 0
 *         (3) adding the new animal would cause the size of the array "animals" to
 *             exceed MAX_ANIMAL_LENGTH
 *        
 */
int addAnimal(const char *species, int id, double hungerScale, const char *habitat)
{
	if ((size + 1) > MAX_ANIMAL_LENGTH) { // if animal array is already full
		return FAILURE;
	}

	size_t speciesLen = my_strlen(species);
	size_t habitatLen = my_strlen(habitat);

	if (speciesLen == 0 || habitatLen == 0) { // if either the species or habitat length are 0
		return FAILURE; 
	}
	
	struct animal newAnimal; //Create new animal struct

	// Copy in species into new animal
	if (speciesLen >= MAX_SPECIES_LENGTH) {
		speciesLen = (MAX_SPECIES_LENGTH - 1);
	}
	my_strncpy(newAnimal.species, species, speciesLen);
	*(newAnimal.species + speciesLen) = 0; // Add null terminator at the end of the string regardless
	
	// Add id to new animal struct
	newAnimal.id = id;

	// Add hunger scale to new animal struct
	newAnimal.hungerScale = hungerScale;

	// Copy in habitat into new animal
	if (habitatLen >= MAX_HABITAT_LENGTH) {
		habitatLen = (MAX_HABITAT_LENGTH - 1);
	}
	my_strncpy(newAnimal.habitat, habitat, habitatLen);
	*(newAnimal.habitat + habitatLen) = 0; // Add null terminator at the end of the string regardless

	animals[size] = newAnimal; //Store the new animal struct in the animal array

	size += 1; // Increment size

	return SUCCESS;

}

/** updateAnimalSpecies
 *
 * @brief updates the species of an existing animal in the array of Animal structs, "animals"
 *
 * @param "animal" Animal struct that exists in the array "animals"
 * @param "species" new species of Animal "animal"
 *               NOTE: if the length of species (including the null terminating character)
 *               is above MAX_SPECIES_LENGTH, truncate species to MAX_SPECIES_LENGTH
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) the Animal struct "animal" can not be found in the array "animals" based on its id
 */
int updateAnimalSpecies(struct animal animal, const char *species)
{
	int searchID = animal.id;
	struct animal currAnimal;
	for (int i = 0; i < size; i++) { //Loop through all the animals in the animal array to check if IDs match
		currAnimal = animals[i]; // Get the current animal in the array
		if (currAnimal.id == searchID) { // Check to see if IDs match
			// Now update the animal species
			size_t speciesLen = my_strlen(species); // Get length of species
			if (speciesLen >= MAX_SPECIES_LENGTH) {
				speciesLen = (MAX_SPECIES_LENGTH - 1); // Truncate species to MAX_SPECIES_LENGTH
			}
			my_strncpy(currAnimal.species, species, speciesLen);
			*(currAnimal.species + speciesLen) = 0; // Add null terminator at the end of the string regardless

			animals[i] = currAnimal;

			return SUCCESS;
		}
	}
	// If we get to the end of the loop and the ID hasn't been found, then return failure
	return FAILURE;
}

/** averageHungerScale
* @brief Search for all animals with the same species and find average the hungerScales
* 
* @param "species" Species that you want to find the average hungerScale for
* @return the average hungerScale of the specified species
*         if the species does not exist, return 0.0
*/
double averageHungerScale(const char *species)
{
	double avgHunger = 0.0; // Inititially hold running total
	double tot = 0.0; // holds the number of animals with the same species
	struct animal currAnimal; // holds the current animal

	for (int i = 0; i < size; i++) { //Loop through all the animals in the animal array to check if species match
		currAnimal = animals[i]; // Get the current animal in the array

		if (my_strncmp(currAnimal.species, species, my_strlen(species)) == 0) { // Checks to see if species are the same
			avgHunger += currAnimal.hungerScale;
			tot += 1.0;
		}
	}

	if (tot == 0.0) {
		return 0.0;
	}

	avgHunger = avgHunger / tot; // gets the final average huner

	return avgHunger;
}

/** swapAnimals
 *
 * @brief swaps the position of two Animal structs in the array of Animal structs, "animals"
 *
 * @param "index1" index of the first Animal struct in the array "animals"
 * @param "index2" index of the second Animal struct in the array "animals"
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) "index1" and/or "index2" are negative numbers
 *         (2) "index1" and/or "index2" are out of bounds of the array "animals"
 */
int swapAnimals(int index1, int index2)
{
	if (index1 < 0 || index2 < 0) { //Fails if either index is negative
		return FAILURE;
	}
	if (index1 >= size || index2 >= size) { // Fails if either index is outside the bounds of the array
		return FAILURE;
	}
	struct animal holder;
	holder = animals[index1];
	animals[index1] = animals[index2];
	animals[index2] = holder;

	return SUCCESS;
}

/** compareHabitat
 *
 * @brief compares the two Animals animals' habitats (using ASCII)
 *
 * @param "animal1" Animal struct that exists in the array "animals"
 * @param "animal2" Animal struct that exists in the array "animals"
 * @return negative number if animal1 is less than animal2, positive number if animal1 is greater
 *         than animal2, and 0 if animal1 is equal to animal2
 */
int compareHabitat(struct animal animal1, struct animal animal2)
{
	int result = my_strncmp(animal1.habitat, animal2.habitat, MAX_HABITAT_LENGTH);

  return result;
}

/** removeAnimal
 *
 * @brief removes Animal in the array of Animal structs, "animals", that has the same species
 *
 * @param "animal" Animal struct that exists in the array "animals"
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) the Animal struct "animal" can not be found in the array "animals"
 */
int removeAnimal(struct animal animal)
{
	int searchID = animal.id;
	struct animal currAnimal;
	for (int i = 0; i < size; i++) { //Loop through all the animals in the animal array to check if IDs match
		currAnimal = animals[i]; // Get the current animal in the array
		if (currAnimal.id == searchID) { // Check to see if IDs match
			// Now delete the animal from the Arr
			if (i == (size - 1)) { // if animal is at the end of the array, just decrement the size and animal would be garbage collected
				size--;
			}
			else {
				for (int x = i; x < (size - 1); x++) { // Move removed animal to the end of the array and then decrement size to garbage collect it
					swapAnimals(x, (x + 1));
				}
				size--;
			}
			return SUCCESS;
		}
	}
	// If we get to the end of the loop and the ID hasn't been found, then return failure
	return FAILURE;
}

/** sortAnimal
 *
 * @brief using the compareHabitat function, sort the Animals in the array of
 * Animal structs, "animals," by the animals' habitat
 * If two animals have the same habitat, place the hungier animal first
 *
 * @param void
 * @return void
 */
void sortAnimalsByHabitat(void)
{
	// Implement a bubble sort
	
	int compare;

	for (int i = 0; i < size - 1; i++) { // Standard set up for bubble sort
		for (int j = 0; j < size - i - 1; j++) {
			compare = compareHabitat(animals[j], animals[j + 1]); // Compare two animals
			if (compare > 0) { // if animal2's habitat is greater then swap
				swapAnimals(j, (j + 1));
			}
			else if (compare == 0) { // if habitats are the same, then swap based on hunger
				if (animals[j + 1].hungerScale > animals[j].hungerScale) {
					swapAnimals(j, (j + 1));
				}
			}
		}
	}

}



