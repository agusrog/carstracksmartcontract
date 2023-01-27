// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CarsTrackContract is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct Brand {
        string company;
        string model;
    }

    struct Note {
        string title;
        string desc;
        uint256 year;
        address signer;
    }

    struct Car {
        uint256 tokenId;
        string domain;
        Brand brand;
        uint256 year;
        Note[] notesList;
        uint256 totalNotes;
    }

    mapping (uint256 => Car) public cars;

    mapping (uint8 => string) private meta;

    constructor() ERC721("CarsTrackContract", "CTRD") {
        _setMeta();
    }

    function safeMint(address to, string memory _domain, string memory _company, string memory _model, uint8 _meta) public onlyOwner {
        
        string memory message = "Algo salio mal, revisa los parametros";
        require(_meta >= 0, message);
        require(_meta < 8, message);
        string memory uri = meta[_meta];

        uint256 tokenId = _tokenIdCounter.current();
        
        _addCar(tokenId, _domain, _company, _model, to);
        _safeMint(to, tokenId);        
        _setTokenURI(tokenId, uri);
        _tokenIdCounter.increment();
    }

    function _addCar(uint256 _tokenId, string memory _domain, string memory _company, string memory _model, address to) private {
                
        Brand memory brand = Brand(_company, _model);

        cars[_tokenId].tokenId = _tokenId;
        cars[_tokenId].domain = _domain;
        cars[_tokenId].brand = brand;
        cars[_tokenId].year = block.timestamp;
        cars[_tokenId].notesList.push(Note("Registro", "Creacion de la unidad", block.timestamp, to));
        cars[_tokenId].totalNotes = 1;
    }

    function addNote(uint256 _tokenId, string memory _title, string memory _desc) public {
        address owner = this.ownerOf(_tokenId);
        require(msg.sender == owner, "Usuario no autorizado");
        Note memory newNote = Note(_title, _desc, block.timestamp, owner);
        cars[_tokenId].notesList.push(newNote);
        cars[_tokenId].totalNotes++;
    }

    function viewNoteByCarIdAndNoteId(uint256 _tokenId, uint256 _noteId) public view returns (Note memory) {
        return cars[_tokenId].notesList[_noteId];
    }

    // The following functions are overrides required by Solidity.

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override (ERC721, IERC721) {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        addNote(tokenId, "Cambio de propiedad", "Transferencia de la unidad");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }   


    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _setMeta () private {
        meta[0] = "https://gateway.pinata.cloud/ipfs/QmZaFNtW548837FWn5Egtt94qq5PPV85wXs6nrbH7VdfLL";
        meta[1] = "https://gateway.pinata.cloud/ipfs/QmU9GT4NvKDpxZMh9dxMf4VuRAXZYM6Gje3D4Vhvwazj3z";
        meta[2] = "https://gateway.pinata.cloud/ipfs/QmZ3pyBUh5DYvK5cva89N8BjpxdwgKYFLW47ctkAiiUVZC";
        meta[3] = "https://gateway.pinata.cloud/ipfs/QmSj6S33Qx8dk8Y9Zzt1vvtVmVbsBdEAfZGP3sRCCzCmi8";
        meta[4] = "https://gateway.pinata.cloud/ipfs/QmdPHFDnMo91tYEKFLtPGQG51NsUykT5DduwSSWhybBbat";
        meta[5] = "https://gateway.pinata.cloud/ipfs/QmWoHvfUySSftnop9E86VbC5CsYDc3dGH6kQN7VqQzGi1N";
        meta[6] = "https://gateway.pinata.cloud/ipfs/QmPjztujqzoKuFcBetPAfhKW2cXDJic4ur5D3ghtgnhfsG";
        meta[7] = "https://gateway.pinata.cloud/ipfs/Qmd8SkWVPX5DHTfj2sLJpqqks48oQRjWGYGBj3vnDtinWD";
    }
}