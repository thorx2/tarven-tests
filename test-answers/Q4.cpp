// Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string &recipient, uint16_t itemId)
{
    Player *player = g_game.getPlayerByName(recipient);

    // Flag should make sense, only delete if created
    // if function returns correct data, do not delete and assume
    // managed elsewhere
    bool createdNewPlayer = false;

    if (!player)
    {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient))
        {
            // Fix leak - 1
            delete player;
            return;
        }
        createdNewPlayer = true;
    }

    // Assuming factory returns a pointer to an allocated data block
    // I will presume I would need to manually delete it if required
    Item *item = Item::CreateItem(itemId);
    if (!item)
    {
        if (createdNewPlayer)
        {
            // Fix leak - 2
            delete player;
        }
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    /*
    * Not deleting the 'item' as it would be saved in some internal DB within the
    * internalAddItem, and hence should be managed from within that function.
    */

    if (player->isOffline())
    {
        // Does this save create a new copy? or just save the data pointer to some array?
        // Assuming the later as that is a better practice, null delete the object otherwise
        // hence the if-else ladder rather than an separate if condition.
        IOLoginData::savePlayer(player);
    }
    else if (createdNewPlayer)
    {
        // Fix leak - 3
        delete player;
    }
}


/// Ignore everything below, used as a scratch pad
/*
#include <string>

#define INDEX_WHEREEVER = 'q'
#define FLAG_NOLIMIT = 'c'

class IOLoginData;

class Game
{
public:
    void addItemToPlayer(const std::string &recipient, uint16_t itemId);
    Player *getPlayerByName(const std::string &recipient);

private:
    Game &g_game;
    void internalAddItem(void *data, Item *item, char l, char q);
};

class Player
{
public:
    Player(void *data);
    bool isOffline();
    void *getInbox();
};
class Item
{
public:
    static Item *CreateItem(uint16_t id);
};

class IOLoginData
{
public:
    static bool loadPlayerByName(Player *player, const std::string &recipient);
    static void savePlayer(Player *player);
};

// Actual question below
void Game::addItemToPlayer(const std::string &recipient, uint16_t itemId)
{
    Player *player = g_game.getPlayerByName(recipient);
    if (!player)
    {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient))
        {
            return;
        }
    }

    Item *item = Item::CreateItem(itemId);
    if (!item)
    {
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline())
    {
        IOLoginData::savePlayer(player);
    }

    //Delete created item from the factory class line
    //Assuming the data has been clearly saved internally within internalAddItem
    delete item;
}
*/