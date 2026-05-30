# Çivit (Twitter Clone) - Kullanıcı Hikayeleri ve Kabul Kriterleri (User Stories & Acceptance Criteria)

Bu belgede, **Çivit** mikroblog platformunun MVP (V1) kapsamındaki 10 temel özelliği için hazırlanan kullanıcı hikayeleri (User Stories) ve Gherkin standardına uygun kabul kriterleri (Acceptance Criteria) yer almaktadır.

---

## 1. Esnek Kimlik Doğrulama (Flexible Authentication)

### **US #1**
> **As a** developer like Yiğit,  
> **I want to** log in using either my unique username or my email address,  
> **so that** I can easily access my account without remembering which credential I registered with.

* **Acceptance Criteria 1 (Username Login):**
  * **Given** I have a registered account with username `"yigit_dev"` and email `"yigit@example.com"`.
  * **When** I enter `"yigit_dev"` in the login field and my correct password, then click "Giriş Yap".
  * **Then** I should be successfully authenticated and redirected to my home timeline.

* **Acceptance Criteria 2 (Email Login):**
  * **Given** I am on the login page.
  * **When** I enter `"yigit@example.com"` in the login field and my correct password, then click "Giriş Yap".
  * **Then** I should be successfully logged in.

* **Acceptance Criteria 3 (Failed Authentication):**
  * **Given** I enter incorrect credentials in the form.
  * **When** I submit the form.
  * **Then** the login should fail and the system should display a Turkish error message: *"Geçersiz e-posta, kullanıcı adı veya şifre."*

---

## 2. Tweet Gönderimi (Tweet Creation)

### **US #2**
> **As a** developer like Yiğit,  
> **I want to** write and publish a text post within a 280-character limit,  
> **so that** I can instantly share my programming thoughts and code tips with my community.

* **Acceptance Criteria 1 (Successful Post via Hotwire):**
  * **Given** I am logged in and on the homepage feed.
  * **When** I type a 120-character technical tip in the tweet composer and click "Çivitle".
  * **Then** my tweet should be created and dynamically prepended to the feed instantly via Turbo Streams without a full page reload.

* **Acceptance Criteria 2 (Character Count Limit):**
  * **Given** I am in the tweet composer.
  * **When** I attempt to type or submit a tweet that exceeds 280 characters.
  * **Then** the system should prevent submission and display a validation error.

---

## 3. Sayfa Yenilemesiz Canlı Beğeni (Live Likes)

### **US #3**
> **As a** designer like Defne,  
> **I want to** like a tweet with a single tap,  
> **so that** I can instantly show appreciation for a design tip without interrupting my reading flow with a full page refresh.

* **Acceptance Criteria 1 (Like Action):**
  * **Given** I am logged in and viewing another user's tweet on my feed.
  * **When** I click the "Beğen" (heart) button.
  * **Then** the like count next to the heart icon should increment by 1 instantly, the heart should turn solid red, and no browser reload should occur.

* **Acceptance Criteria 2 (Unlike Action):**
  * **Given** I have already liked a tweet (heart is solid red).
  * **When** I click the heart button again.
  * **Then** the like count should decrement by 1 instantly, the heart should revert to its default outline state, and no page refresh should occur.

---

## 4. Turbo Stream Destekli Yorum Sistemi (Live Comments)

### **US #4**
> **As a** designer like Defne,  
> **I want to** reply directly to a tweet with a feedback comment,  
> **so that** I can provide immediate and constructive UI/UX critiques under specific posts.

* **Acceptance Criteria 1 (Comment Addition):**
  * **Given** I am logged in and viewing a tweet's detail page.
  * **When** I write a feedback message in the comment input box and click "Yorum Yap".
  * **Then** my comment should immediately render at the bottom of the comment list without reloading the page, and the comment count of the tweet should increment by 1.

* **Acceptance Criteria 2 (Validation):**
  * **Given** I am on the comment input form.
  * **When** I try to submit an empty comment.
  * **Then** the system should block the submission and show a dynamic warning message.

---

## 5. Kullanıcı Takip Sistemi (Follow Mechanism)

### **US #5**
> **As a** designer like Defne,  
> **I want to** follow Yiğit,  
> **so that** his technical Rails updates are automatically curated and displayed in my chronological home feed.

* **Acceptance Criteria 1 (Follow Action):**
  * **Given** I am logged in and visiting Yiğit's public profile page.
  * **When** I click the "Takip Et" button.
  * **Then** the button should instantly update to "Takip Ediliyor" (Following), and his follower count on the screen should increment by 1.

* **Acceptance Criteria 2 (Unfollow Action):**
  * **Given** I am currently following Yiğit.
  * **When** I click the "Takip Ediliyor" button on his profile.
  * **Then** the relationship should be removed, the button should revert to "Takip Et", and his follower count should decrement by 1.

---

## 6. Algoritmasız Kronolojik Akış (Chronological Timeline)

### **US #6**
> **As a** developer like Yiğit,  
> **I want to** view my home timeline sorted strictly in reverse-chronological order,  
> **so that** I can read the newest tech updates in real-time without artificial algorithmic sorting.

* **Acceptance Criteria 1 (Newest First):**
  * **Given** I am logged in and follow three active users.
  * **When** I load the homepage.
  * **Then** I should see tweets only from myself and the users I follow, sorted with the most recently published tweets at the very top.

* **Acceptance Criteria 2 (No Ads/Sponsored Posts):**
  * **Given** I am scrolling my timeline.
  * **When** I scroll past 10 tweets.
  * **Then** I should only see organic posts, confirming that no sponsored posts or algorithmically suggested accounts are injected into my chronological feed.

---

## 7. Kelime ve Kullanıcı Arama Motoru (Real-Time Search)

### **US #7**
> **As a** developer like Yiğit,  
> **I want to** search for terms like 'Rails 8' or specific usernames,  
> **so that** I can quickly find relevant technical posts and discover new Ruby developers to follow.

* **Acceptance Criteria 1 (Keyword Search):**
  * **Given** I am on the search bar.
  * **When** I type `"Rails 8"` and press Enter.
  * **Then** the page should list all tweets containing the phrase `"Rails 8"` and users whose usernames contain `"rails"`.

* **Acceptance Criteria 2 (No Results):**
  * **Given** I search for a non-existent random string like `"xyzqwe123"`.
  * **When** the query is executed.
  * **Then** I should see a clean, user-friendly state: *"Sonuç bulunamadı."*

---

## 8. Karanlık Mod Tema Desteği (Dark Mode Toggle)

### **US #8**
> **As a** developer like Yiğit,  
> **I want to** switch between light and dark modes with a single click,  
> **so that** I can comfortably read the feed during my late-night coding sessions without eye strain.

* **Acceptance Criteria 1 (Toggle Theme):**
  * **Given** the platform is currently rendering in default Light Mode.
  * **When** I click the "Tema Değiştir" (Theme Toggle) button in the sidebar.
  * **Then** the entire application interface should immediately shift to a dark glassmorphic layout using Tailwind CSS 4 variables, and my choice should be saved in my browser's local storage.

* **Acceptance Criteria 2 (Persisted Preference):**
  * **Given** my theme preference is saved as `"dark"` in my browser.
  * **When** I open the platform in a completely new browser tab or reload.
  * **Then** the platform should load in Dark Mode by default.

---

## 9. Kendi Tweetini Silme (Own Tweet Deletion)

### **US #9**
> **As a** developer like Yiğit,  
> **I want to** delete my own outdated or accidental tweets,  
> **so that** I can keep my public profile clean and up-to-date with my best tech tips.

* **Acceptance Criteria 1 (Successful Deletion):**
  * **Given** I am logged in and viewing one of my own tweets on the profile page.
  * **When** I click the "Sil" (Delete) button next to the tweet and confirm the prompt.
  * **Then** the tweet should immediately disappear from the feed via Turbo Stream, and it must be completely deleted from the database.

* **Acceptance Criteria 2 (No Unauthorized Deletion):**
  * **Given** I am logged in and viewing a tweet published by Defne.
  * **When** I hover or click on her tweet card.
  * **Then** the "Sil" (Delete) button should be entirely hidden from my interface.

---

## 10. Profil Bilgisi Özelleştirme (Profile Customization)

### **US #10**
> **As a** designer like Defne,  
> **I want to** update my display name and edit my bio,  
> **so that** I can inform my followers about my latest freelance UI/UX availability and link my Substack newsletter.

* **Acceptance Criteria 1 (Successful Bio Edit):**
  * **Given** I am logged in and visiting my profile settings screen.
  * **When** I change my bio to `"UI/UX Designer @ Freelance | Substack Curator"` and click "Değişiklikleri Kaydet".
  * **Then** I should be redirected to my profile page, where the updated bio and display name are rendered instantly.

* **Acceptance Criteria 2 (Username Validation):**
  * **Given** I am in the edit profile form.
  * **When** I attempt to clear my username field entirely or use illegal special characters.
  * **Then** the form should fail validation, prevent submission, and display the errors in Turkish.
